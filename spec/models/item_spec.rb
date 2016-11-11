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
    let(:item) { FactoryGirl.build_stubbed(:item, name: 'Some Item') }
    let(:restaurant_path_name) { 'some_restaurant' }

    before do
      allow(item).to receive(:restaurant_image_path_suffix) { '' }
    end

    context 'with image asset' do
      it 'returns the image path' do
        path_name = 'app/assets/images/restaurants/some_restaurant/items/some_item.jpeg'

        allow(Dir).to receive(:[]) { [path_name] }

        path = item.image_path

        expect(path).to eq 'restaurants/some_restaurant/items/some_item.jpeg'
      end
    end

    context 'without image asset' do
      it 'returns a placeholder string' do
        allow(Dir).to receive(:[]) { [] }

        path = item.image_path

        expect(path).to eq '#'
      end
    end

    context 'without #image_path_suffix definded' do
      it 'returns an error' do
        allow(item).to receive(:respond_to?) { nil }

        begin
          item.image_path
        rescue Error::UndefinedMethod => e
          error_thrown = true
        end

        expect(error_thrown).to eq true
      end
    end
  end
end
