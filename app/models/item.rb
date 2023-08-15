# == Schema Information
#
# Table name: items
#
#  id         :bigint           not null, primary key
#  page_name  :string
#  text       :text
#  embedding  :vector(1536)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Item < ApplicationRecord
  after_save :populate_embedding_async, if: :saved_change_to_text?
  after_commit :parse_pdf_text, on: :create, if: :pdf_file_attached?

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
