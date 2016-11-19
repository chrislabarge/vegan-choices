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

    it 'allows for nested ingredients' do
      ingredients = 'Complicated Flour (Some complicated, Stuff), Water'

      allow(item).to receive(:ingredients) { ingredients }

      list = item.ingredient_list
      nested = list.map(&:nested).flatten.compact

      expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
      expect(nested.count).to eq 2
      expect(nested.map(&:name)).to eq ['Some complicated', 'Stuff']
    end

    context 'ingredient string contains "and/or"' do
      it 'allows for "and" Ingredients' do
        ingredients = 'Complicated Flour and Stuff, Water'

        allow(item).to receive(:ingredients) { ingredients }

        list = item.ingredient_list
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'and'
      end

      it 'allows for "or" Ingredients' do
        ingredients = 'Complicated Flour or Stuff, Water'

        allow(item).to receive(:ingredients) { ingredients }

        list = item.ingredient_list
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'or'
      end

      it 'allows for "and/or" Ingredients' do
        ingredients = 'Complicated Flour and/or Stuff, Water'

        allow(item).to receive(:ingredients) { ingredients }

        list = item.ingredient_list
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'and/or'
      end
    end

    context 'name has a description' do

    end

    # context 'when ingredients attribute contains a string' do
    #   it 'split string into a list by commas' do
    #     ingredients = 'Malted Barley Flour, Water'

    #     allow(item).to receive(:ingredients) { ingredients }

    #     list = item.ingredient_list

    #     expect(list).to eq ['Malted Barley Flour', 'Water']
    #   end

    #   it 'allows for nested ingredients' do
    #     ingredients = 'Complicated Flour (Some complicated, [stuff]), Water'

    #     allow(item).to receive(:ingredients) { ingredients }

    #     list = item.ingredient_list

    #     expect(list).to eq [['Complicated Flour', ['Some complicated', '[stuff]']], 'Water']
    #   end

    #   it 'removes escaped newline character "\n"' do
    #     ingredients = "Complicated Flour (Some \ncomplicated, [stuff]), \nWater"

    #     allow(item).to receive(:ingredients) { ingredients }

    #     list = item.ingredient_list

    #     expect(list).to eq [['Complicated Flour', ['Some complicated', '[stuff]']], 'Water']
    #   end

    #   it 'splits strings that contain "and"' do
    #     ingredients = "Complicated Flour (Some complicated stuff and Things), Water and Juice"

    #     allow(item).to receive(:ingredients) { ingredients }

    #     list = item.ingredient_list

    #     expect(list).to eq [['Complicated Flour', ['Some complicated stuff', 'Things']], 'Water', 'Juice']
    #   end
    # end
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

        expect(path).to eq '#'
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
    # add the tests to make sure stuff is logged and outputed to the console
  end
end
