require 'rails_helper'

RSpec.describe Item, type: :model do
  it { should belong_to(:restaurant).inverse_of(:items) }
  it { should belong_to(:item_type).inverse_of(:items) }

  it { should validate_presence_of(:name) }

  it { should delegate_method(:path_name).to(:restaurant).with_prefix true }

  it { is_expected.to callback(:no_image_file_notification).after(:save) }

  describe '#ingredient_list' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    let(:ingredients) { 'A Ingredient, Another Ingredient' }

    it 'returns a list of Ingredient instances' do
      allow(item).to receive(:ingredients) { ingredients }

      list = item.ingredient_list

      expect(list.map(&:name)).to eq ['A Ingredient', 'Another Ingredient']
    end
  end

  describe '#path_name' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    it 'substitutes spaces for underscores' do
      name = 'Some Item'

      allow(item).to receive(:name) { name }

      path_name = item.path_name

      expect(path_name).to eq 'some_item'
    end

    it 'downcases' do
      name = 'Item'

      allow(item).to receive(:name) { name }

      path_name = item.path_name

      expect(path_name).to eq 'item'
    end

    it 'removes punctuation' do
      name = "Item's"

      allow(item).to receive(:name) { name }

      path_name = item.path_name

      expect(path_name).to eq 'items'
    end

    it 'accepts arguments' do
      name = 'Some Argument Name'
      path_name = item.path_name(name)

      expect(path_name).to eq 'some_argument_name'
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

        expect(path).to eq nil
      end
    end

    context 'without #image_path_suffix definded' do
      it 'returns an error' do
        allow(item).to receive(:respond_to?) { nil }

        begin
          item.image_path
        rescue Error::UndefinedMethod
          error_thrown = true
        end

        expect(error_thrown).to eq true
      end
    end
  end

  describe '#no_image_file_notification' do
    # TODO: add the tests to make sure stuff is logged and outputed to the console
  end
end
