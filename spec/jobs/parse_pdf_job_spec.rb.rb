require 'rails_helper'

RSpec.describe ParsePdfJob, type: :job do
  describe '#perform' do
    it 'parses the pdf content and updates the item text' do
      # Create a temporary PDF file with sample content
      pdf_file = Tempfile.new(['sample', '.pdf'])
      pdf_content = "This is a sample PDF file for testing."
      Prawn::Document.generate(pdf_file.path) do
        text pdf_content
      end

      # Create an Item and attach the temporary PDF file
      item = create(:item)
      item.pdf_file.attach(io: pdf_file, filename: 'sample.pdf')

      # Perform the job
      ParsePdfJob.perform_now(item.id)

      # Verify that the item's text has been updated with the PDF content
      item.reload
      expect(item.text).to eq(pdf_content)

      # Close and unlink the temporary file
      pdf_file.close
      pdf_file.unlink
    end

    it 'does not update the item text if pdf file is not attached' do
      # Create an Item without a pdf file
      item = create(:item)

      # Perform the job
      ParsePdfJob.perform_now(item.id)

      # Verify that the item's text remains unchanged
      item.reload
      expect(item.text).to eq('Text')
    end
  end
end