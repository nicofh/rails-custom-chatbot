# == Schema Information
#
# Table name: items
#
#  id               :bigint           not null, primary key
#  name             :string
#  text             :text
#  embedding        :vector(1536)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  previous_item_id :bigint
#
# Indexes
#
#  index_items_on_previous_item_id  (previous_item_id)
#
class Item < ApplicationRecord
  after_save :populate_embedding_async, if: :saved_change_to_text?
  after_commit :parse_pdf_text, on: :create, if: :pdf_file_attached?

  belongs_to :previous_item, class_name: 'Item', optional: true
  has_one :next_item, class_name: 'Item', foreign_key: 'previous_item_id',
                      inverse_of: :previous_item, dependent: :destroy
  has_neighbors :embedding
  has_one_attached :pdf_file

  private

  def pdf_file_attached?
    pdf_file.attached?
  end

  def populate_embedding_async
    EmbeddingPopulateJob.perform_later(id)
  end

  def parse_pdf_text
    ParsePdfJob.perform_later(id)
  end
end
