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
FactoryBot.define do
  factory :item do
    page_name { 'PageName' }
    text { 'Text' }
    embedding { Array.new(1536, 0.0) }
  end
end
