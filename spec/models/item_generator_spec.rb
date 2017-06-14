require 'rails_helper'

RSpec.describe ItemGenerator, type: :model do
  subject { ItemGenerator }

  describe '#generate' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    let(:restaurant) { item.restaurant }
    let(:generator) { subject.new(restaurant) }

      it 'generates new items' do
        allow(generator).to receive(:gather_data_from_sources) { ['data', 'more date'] }
        allow(Item).to receive(:new) { item }

        actual = generator.generate

        expect(actual).to include item
      end
  end

  describe '#gather_data_from_sources' do
    let(:restaurant) { FactoryGirl.build_stubbed(:restaurant) }
    let(:generator) { subject.new(restaurant) }
    let(:listings) { double('listings') }
    let(:scoped_listings) { double('scoped_listings') }
    let(:online_scope) { :online }
    let(:documents_scope) { :documents }

    scopes =  [:online, :documents]


    scopes.each do |scope|
      it "generates items from #{scope} item listings" do
        data = ['French Fries', 'Potatoes']
        other_scope = (scopes - [scope]).last

        allow(restaurant).to receive(:item_listings) { listings }
        allow(listings).to  receive(scope)  { scoped_listings }
        allow(listings).to  receive(other_scope)  { [] }
        allow(generator).to receive(:extract_data_from_listings).with(scoped_listings, scope) { data }

        actual = generator.gather_data_from_sources

        expect(actual).to eq(data)
      end
    end


    it 'generates items from both item listing scopes' do
      data = ['French Fries', 'Potatoes']

      allow(restaurant).to receive(:item_listings) { listings }
      scopes.each do |scope|
        allow(listings).to  receive(scope)  { scoped_listings }
      end
      allow(generator).to receive(:extract_data_from_listings) { data }

      actual = generator.gather_data_from_sources
      expected = [data, data].flatten

      expect(actual).to eq(expected)
    end
  end
end
