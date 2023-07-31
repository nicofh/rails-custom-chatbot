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
  describe 'associations' do
    it { should have_one_attached(:pdf_file) }
  end

  describe 'callbacks' do
    let(:item) { build(:item) }

    context 'when pdf file is attached' do
      before { allow(item.pdf_file).to receive(:attached?).and_return(true) }

      it 'triggers parse_pdf_text after commit on create' do
        expect(item).to receive(:parse_pdf_text)
        item.save!
      end
    end

    context 'when text is changed' do
      before { item.text = 'New text' }

      it 'triggers populate_embedding_async after save' do
        expect(item).to receive(:populate_embedding_async)
        item.save!
      end
    end

    context 'when text is not changed' do
      before { item.save! }
      it 'does not trigger populate_embedding_async after save' do
        expect(item).not_to receive(:populate_embedding_async)
        item.update!(page_name: 'New page name')
      end
    end
  end
end

