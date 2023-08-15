require 'rails_helper'

RSpec.describe EmbeddingPopulateJob, type: :job do
  describe '#perform' do
    let(:item) { create(:item, text: 'Sample text to test embedding') }
    let(:mock_embedded_text) { Array.new(1536, 3.4) }

    it 'generates and updates embedding for the item' do
      # Stub the LlmService#generate_embedding_for method to return a mock embedded_text
      llm_service = instance_double(LlmService)
      allow(LlmService).to receive(:new).and_return(llm_service)
      allow(llm_service).to receive(:generate_embedding_for).and_return(mock_embedded_text)

      # Execute the job
      EmbeddingPopulateJob.perform_now(item.id)

      # Reload the item to get the updated attributes from the database
      item.reload

      # Verify that the embedding has been updated
      expect(item.embedding).to eq(mock_embedded_text)
    end

    it 'rescues and logs StandardError' do
      allow(Rails.logger).to receive(:error)

      item_id = 9999 # Assuming there's no item with ID 9999 in the database

      # Execute the job with a non-existing item ID
      EmbeddingPopulateJob.perform_now(item_id)

      # Verify that the error has been logged
      expect(Rails.logger)
        .to have_received(:error)
        .with(/Error while populating embedding for Item #{item_id}/)
    end
  end
end
