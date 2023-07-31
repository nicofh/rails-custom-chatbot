class ParsePdfJob < ApplicationJob
  queue_as :default

  def perform(item_id)
    item = Item.find(item_id)
    return unless item.pdf_file.attached?

    pdf_content = item.reload.pdf_file.download
    reader = PDF::Reader.new(StringIO.new(pdf_content))
    pdf_text = reader.pages.map(&:text).join("\n")

    item.update!(text: pdf_text)
  end
end
