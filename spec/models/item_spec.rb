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
require 'rails_helper'

RSpec.describe Item, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
