require 'rails_helper'

RSpec.describe ItemGenerator, type: :model do
  subject { ItemGenerator }

  describe '#generate' do
    let(:restaurant) { FactoryGirl.build_stubbed(:restaurant) }
    let(:item) { FactoryGirl.create(:item, restaurant: restaurant) }
    let(:name) { 'name' }
    let(:ingredients) { 'some ingredients' }
    let(:generator) { subject.new(restaurant) }
    let(:extractor) { double('extractor') }

      it 'generates new items' do
        allow(extractor).to receive(:extract) { [name, ingredients] }
        allow(ItemDataExtractor).to receive(:new) { extractor }

        actual = generator.generate

        expect(actual.map(&:name)).to include name
        expect(actual.map(&:ingredient_string)).to include ingredients
      end
  end
end
