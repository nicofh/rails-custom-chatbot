class EmbeddingPopulateJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    item = Item.find(item_id)
    embedded_text = LlmService.new.generate_embedding_for(item.text)
    item.update!(embedding: embedded_text)
  rescue StandardError => e
    Rails.logger.error("Error while populating embedding for Item #{item_id}: #{e.message}")
  end
end
