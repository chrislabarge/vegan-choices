require 'rails_helper'

RSpec.describe ItemDataExtractor, type: :model do
  subject { ItemDataExtractor }

  describe '#gather_data_from_sources' do
    let(:restaurant) { FactoryBot.build_stubbed(:restaurant) }
    let(:extractor) { subject.new(restaurant) }
    let(:listings) { double('listings') }
    let(:scoped_listings) { double('scoped_listings') }
    let(:online_scope) { :online }
    let(:documents_scope) { :documents }

    scopes =  [:online, :documents]

    scopes.each do |scope|
      it "extracts data from #{scope} item listings" do
        data = ['French Fries', 'Potatoes']
        other_scope = (scopes - [scope]).last

        allow(restaurant).to receive(:item_listings) { listings }
        allow(listings).to  receive(scope)  { scoped_listings }
        allow(listings).to  receive(other_scope)  { [] }
        allow(extractor).to receive(:collect_data_from_listings).with(scoped_listings, scope) { data }

        actual = extractor.extract

        expect(actual).to eq(data)
      end
    end


    it 'extracts the data from both item listing scopes' do
      data = ['French Fries', 'Potatoes']

      allow(restaurant).to receive(:item_listings) { listings }
      scopes.each do |scope|
        allow(listings).to receive(scope)  { scoped_listings }
        allow(extractor).to receive(:collect_data_from_listings).with(scoped_listings, scope) { data }
      end

      actual = extractor.extract
      expected = [data, data].flatten

      expect(actual).to eq(expected)
    end
  end
end
