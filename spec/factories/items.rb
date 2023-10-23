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
FactoryBot.define do
  factory :item do
    name { 'Name' }
    text { 'Text' }
    embedding { Array.new(1536, 0.0) }

    trait :with_pdf_file do
      transient do
        pdf_content { 'This is a sample PDF file for testing.' }
      end

      after(:build) do |item, evaluator|
        pdf_file = Tempfile.new(['sample', '.pdf'])
        Prawn::Document.generate(pdf_file.path) do
          text evaluator.pdf_content
        end
        item.pdf_file.attach(io: pdf_file, filename: 'sample.pdf')
      end
    end
  end
end
