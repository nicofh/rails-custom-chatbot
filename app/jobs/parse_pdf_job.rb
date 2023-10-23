class ParsePdfJob < ApplicationJob
  queue_as :default

  MAX_CHAR_LENGTH = 4000
  BATCH_SIZE = 100

  def perform(item_id)
    item = Item.find(item_id)
    return unless item.pdf_file.attached?

    pdf_text = extract_pdf_text(item)

    pdf_chunks = pdf_text.scan(/.{1,#{MAX_CHAR_LENGTH}}/m)
    @part_number = 2

    # Iterate through the chunks, creating Item records and linking them
    item.update!(text: pdf_chunks.first, name: @pdf_title)
    previous_item = item
    pdf_chunks[1..].each_slice(BATCH_SIZE) do |chunk_batch|
      previous_item = create_items_batch(previous_item, chunk_batch)
    end
  end

  private

  def extract_pdf_text(item)
    pdf_content = item.reload.pdf_file.download
    reader = PDF::Reader.new(StringIO.new(pdf_content))
    @pdf_title = item.name || reader.info[:Title]
    pdf_text = reader.pages.map(&:text).join("\n")

    pdf_text.gsub!("\n", '')
    pdf_text.gsub!(/^\s*$/, '')
    pdf_text
  end

  def create_items_batch(previous_item, chunk_batch)
    new_items = []
    last_item = previous_item

    chunk_batch.each do |chunk|
      name = "#{@pdf_title} Part #{@part_number}"
      last_item = Item.create!(previous_item_id: last_item.id, text: chunk, name:)
      new_items << last_item
      @part_number += 1
    end

    # Item.import(new_items) # Use a bulk insert method to create items in a batch
    last_item # Return the last_item for the next batch
  end
end
