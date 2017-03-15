require 'rails_helper'

RSpec.describe ItemListing, type: :model do
  it { should belong_to(:restaurant).inverse_of(:item_listings) }

  describe 'using to parse listing' do
    let(:parser_options) { { start_string: '', end_string: '' } }
    let(:item_listing) { FactoryGirl.create(:item_listing, filename: 'test', data_extract_options: parser_options) }
    let(:restaurant) { item_listing.restaurant }
    let(:test) { double('test') }

    before do
      # diet
      # allow_any_instance_of(Diet).to receive(:pertains_to?) { true }
    end

    context 'see how item_listing attributes get used in parser' do
      it 'returns a list including the diet' do
        allow(ItemListParser).to receive(:new) { test }
        # allow_any_instance_of(NilClass).to receive(:each_with_index)

        actual = restaurant.generate_items

        expect(test).to receive(:parse).with(item_listing.pathname, item_listing.parser_options)
      end
    end
   end

end
