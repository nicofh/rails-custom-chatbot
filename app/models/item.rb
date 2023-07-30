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

    has_neighbors :embedding

    def populate_embedding_async
        EmbeddingPopulateJob.perform_later(self.id)
    end
  
end
