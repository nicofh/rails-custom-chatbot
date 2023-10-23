require 'rails_helper'

RSpec.describe ParsePdfJob, type: :job do
  describe '#perform' do
    before do
      ParsePdfJob.perform_now(item.id)
    end

    context 'when the item has a small pdf attached' do
      let(:pdf_content) { 'Custom PDF content for testing.' }
      let(:item) { create(:item, :with_pdf_file, pdf_content:) }

      it 'parses the pdf content and updates the item text' do
        item.reload
        expect(item.text).to eq(pdf_content)
      end
    end

    context 'when the item has a pdf file with 3000 chars' do
      let(:pdf_content) { 'A' * 6000 }
      let(:item) do
        create(:item, :with_pdf_file, pdf_content:, name: 'Original PDF Title')
      end

      it 'splits a long pdf into multiple items' do
        item.reload
        # Verify that the item's text has been split into multiple items
        expect(item.text).to eq('A' * 4000) # The first chunk
        expect(Item.count).to eq(2)         # Expecting 2 items
      end

      it 'set the correct naming to each item' do
        item.reload
        expect(item.name).to eq('Original PDF Title')
        expect(Item.second.name).to eq('Original PDF Title Part 2')
      end
    end

    context 'item has no pdf file attached' do
      let(:item) { create(:item) }

      it 'does not update the item text' do
        item.reload
        expect(item.text).to eq('Text')
      end
    end
  end
end
