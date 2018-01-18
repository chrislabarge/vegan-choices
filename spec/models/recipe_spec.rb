require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should belong_to(:item).inverse_of(:recipe) }
  it { should have_many(:recipe_items).inverse_of(:recipe) }
  it { should have_many(:items).through(:recipe_items) }
  it { should have_many(:recipe_item_diets).through(:recipe_items), source: :diets }

  it { should validate_presence_of(:item_id) }

  describe '#diets' do
    context 'when the recipe items have diets' do
      let(:item_diet) { FactoryBot.create(:item_diet) }
      let(:recipe_item) { FactoryBot.create(:recipe_item, item: item) }
      let(:recipe) { recipe_item.recipe }
      let(:item) { item_diet.item }
      let(:diet) { item_diet.diet }

      let(:another_item_diet) { FactoryBot.create(:item_diet) }
      let(:another_item) { another_item_diet.item }
      let(:another_recipe_item) { FactoryBot.create(:recipe_item, recipe: recipe, item: another_item) }
      let(:another_diet) { another_item_diet.diet }

      it 'returns a collection of diets that pertain to all recipe items' do
        FactoryBot.create(:item_diet, item: another_item, diet: diet)

        actual = recipe.diets

        expect(actual).to include diet
        expect(actual).not_to include another_diet
      end

      it 'returns a blank collection when there are no diets that pertain to all recipe items' do
        another_recipe_item

        actual = recipe.diets

        expect(actual).not_to include diet
        expect(actual).not_to include another_diet
        expect(actual).to be_empty
      end
    end

    context 'when the recipe items do not have diets' do
      let(:recipe_item) { FactoryBot.create(:recipe_item) }
      let(:recipe) { recipe_item.recipe }

      it 'returns a blank collection when there are no diets that pertain to all recipe items' do
        actual = recipe.diets

        expect(actual).to be_empty
      end
    end
  end

  describe 'after commit' do
    context 'when recipe is generated or saved' do
      let(:item_diet) { FactoryBot.create(:item_diet) }
      let(:item) { item_diet.item }
      let(:recipe) { FactoryBot.build(:recipe) }
      let(:recipe_item) { FactoryBot.build(:recipe_item, recipe: recipe, item: item) }
      let(:diet) { item_diet.diet }
      let(:item_with_recipe) { recipe.item }

      before do
        allow_any_instance_of(Diet).to receive(:pertains_to?) { true }
      end

      it 'creates a item_diet for the item with the recipe' do
        recipe.recipe_items = [recipe_item]
        recipe.save

        actual = item_with_recipe.item_diets
        diets = actual.map(&:diet)

        expect(actual).not_to be_empty
        expect(diets).to include diet
      end

      it 'does not create a item_diet for the item with the recipe' do
        recipe.save

        actual = item_with_recipe.item_diets
        diets = actual.map(&:diet)

        expect(diets).not_to include diet
        expect(actual).to be_empty
      end

      it 'removes a item diet from the recipe,' do
        item_diet.destroy
        FactoryBot.create(:item_diet, diet: diet, item: item_with_recipe)

        item_diet_count = item_with_recipe.item_diets.count
        recipe.recipe_items = [recipe_item]
        recipe.save

        actual = item_with_recipe.item_diets
        diets = actual.map(&:diet)

        expect(item_with_recipe.item_diets.count).to eq item_diet_count - 1
        expect(diets).not_to include diet
        expect(actual).to be_empty
      end
    end
  end
end
