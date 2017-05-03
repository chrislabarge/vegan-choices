require 'rails_helper'

RSpec.describe RecipeGenerator, type: :model do
  subject { RecipeGenerator }
    let(:item) { FactoryGirl.create(:item) }
    let(:restaurant) { item.restaurant }
    let(:existing_item) { FactoryGirl.create(:item, restaurant: restaurant) }

  describe '#generate' do
    let(:generator) { subject.new }

    it 'generates a recipe with recipe items' do
      allow(item).to receive(:ingredient_string) { existing_item.name }

      actual = generator.generate(item)
      recipe = item.recipe
      items = recipe.items
      expect(actual).to eq true
      expect(recipe).not_to eq nil
      expect(items).to include existing_item
    end


    context 'does not generate a recipe with recipe items when' do
      it 'receives an item with no recipe items within the #ingredient_string' do
        allow(item).to receive(:ingredient_string) { 'SOME INGREDIENT' }

        actual = generator.generate(item)

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end

      it 'receives an item with a nil #ingredient_string' do
        allow(item).to receive(:ingredient_string) { nil }

        actual = generator.generate(item)

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end

      it 'receives an item where the ingredient string contains the item name' do
        #This is happening in build_recipe_items
        allow(item).to receive(:ingredient_string) { item.name }

        actual = generator.generate(item)

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end
    end
  end

  describe 'initialize with restaurant' do
    let(:generator) { subject.new(restaurant) }

    it 'generates a recipe with recipe items' do
      allow(item).to receive(:ingredient_string) { existing_item.name }

      actual = generator.generate(item)
      recipe = item.recipe
      items = recipe.items

      expect(actual).to eq true
      expect(recipe).not_to eq nil
      expect(items).to include existing_item
    end

    context 'does not generate a recipe with recipe items when' do
      it 'receives an item with no recipe items within the #ingredient_string' do
        allow(item).to receive(:ingredient_string) { 'SOME INGREDIENT' }

        actual = generator.generate(item)

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end

      it 'receives an item with a nil #ingredient_string' do
        allow(item).to receive(:ingredient_string) { nil }

        actual = generator.generate(item)

        item.reload

        recipe = item.recipe

        expect(actual).not_to eq true
        expect(recipe).to eq nil
      end
    end
  end
end
