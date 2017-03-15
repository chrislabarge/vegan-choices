require 'rails_helper'

RSpec.describe ItemIngredient, type: :model do
  it { should belong_to(:item).inverse_of(:item_ingredients) }
  it { should belong_to(:ingredient).inverse_of(:item_ingredients) }

  it { should have_many(:item_ingredients).dependent(:destroy) }
  it { should have_many(:ingredients).through(:item_ingredients) }

  it { should delegate_method(:name).to(:ingredient) }

  describe 'scope' do
    it 'scopes the main ItemIngredients' do
      item_ingredient = FactoryGirl.create(:item_ingredient)

      main_item_ingredients = ItemIngredient.main
      nested_item_ingredients = ItemIngredient.nested
      additional_item_ingredients = ItemIngredient.additional

      expect(main_item_ingredients).to include item_ingredient
      expect(nested_item_ingredients).not_to include item_ingredient
      expect(additional_item_ingredients).not_to include item_ingredient
    end

    it 'scopes the nested ItemIngredients' do
      item_ingredient = FactoryGirl.create(:item_ingredient, parent_id: 1)

      main_item_ingredients = ItemIngredient.main
      nested_item_ingredients = ItemIngredient.nested
      additional_item_ingredients = ItemIngredient.additional

      expect(main_item_ingredients).not_to include item_ingredient
    end

    it 'scopes the additional ItemIngredients' do
      item_ingredient = FactoryGirl.create(:item_ingredient, parent_id: 1,
                                                             context: 'and')
      main_item_ingredients = ItemIngredient.main
      nested_item_ingredients = ItemIngredient.nested
      additional_item_ingredients = ItemIngredient.additional

      expect(main_item_ingredients).not_to include item_ingredient
      expect(nested_item_ingredients).not_to include item_ingredient
      expect(additional_item_ingredients).to include item_ingredient
    end
  end
end
