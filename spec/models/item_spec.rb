require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:restaurant).inverse_of(:items) }
  it { should belong_to(:item_type).inverse_of(:items) }

  it { should validate_presence_of(:name) }

  it { should delegate_method(:path_name).to(:restaurant).with_prefix true }

  describe '#ingredient_list' do
    let(:item) { FactoryGirl.build_stubbed(:item) }

    context 'when ingredients attribute contains a string' do
      it 'split string into a list by commas' do
        ingredients = 'Malted Barley Flour, Water'

        allow(item).to receive(:ingredients) { ingredients }

        list = item.ingredient_list

        expect(list).to eq ['Malted Barley Flour', 'Water']
      end

      it 'allows for parenthesis' do
        ingredients = 'Complicated Flour (Some complicated, [stuff]), Water'

        allow(item).to receive(:ingredients) { ingredients }

        list = item.ingredient_list

        expect(list).to eq ['Complicated Flour (Some complicated, [stuff])', 'Water']
      end
    end
  end

  describe '#path_name' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    it 'substitutes spaces for underscores' do
      name = 'Some Item'

      allow(item).to receive(:name) { name }

      list = item.path_name

      expect(list).to eq 'some_item'
    end

    it 'allows for parenthesis' do
      name = 'Item'

      allow(item).to receive(:name) { name }

      list = item.path_name

      expect(list).to eq 'item'
    end
  end

  describe '#image_path' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    it 'returns the image path' do
      path_name = 'app/assets/images/restaurants/some_restaurant/items/some_item.jpeg'

      allow(Dir).to receive(:message) { [path_name] }

      path = item.image_path

      expect(path).to eq 'restaurants/some_restaurant/items/some_item.jpeg'
    end
  end
end
