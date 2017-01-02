require 'rails_helper'

RSpec.describe ItemIngredientParser, type: :model do
  let(:restaurant) { FactoryGirl.create(:restaurant) }
  let(:item_type) { FactoryGirl.create(:item_type) }

  let(:item) { FactoryGirl.create(:item, restaurant: restaurant, item_type: item_type) }
  subject { ItemIngredientParser.new(item) }

  describe '#parse' do
    let(:ingredients_string) { 'Flour, Salt' }

    it 'parses the passed string and returns a collection of ItemIngredients' do
      collection = subject.parse(ingredients_string)

      expect(collection.all? { |i| i.class == ItemIngredient }).to eq true

      expect(collection.map(&:name)).to eq ['Flour', 'Salt']
    end

    context 'an ingredient already exists in the database' do
      it 'does not create a new ingredient to associate to the "ItemIngredient"' do
        ingredient_name = 'Complicated Flour'
        Ingredient.create(name: ingredient_name)
        ingredients_string = ingredient_name
        ingredient_count = Ingredient.all.count

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(Ingredient.count).to eq ingredient_count
        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour']
        expect(nested_ingredients.count).to eq 0
      end

      it 'uses existing ingredient and creates a new one when appropriate' do
        ingredient_name = 'Complicated Flour'
        Ingredient.create(name: ingredient_name)
        ingredients_string = "#{ingredient_name}, A new Ingredient"
        ingredient_count = Ingredient.all.count

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(Ingredient.count).to eq ingredient_count + 1
        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'A new Ingredient']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'A new Ingredient']
        expect(nested_ingredients.count).to eq 0
      end
    end

    context 'ingredient string has nested content from "()" pathenthese' do
      it 'associates the nested ingredients' do
        ingredients_string = 'Complicated Flour (Some complicated, Stuff), Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredients_string = 'Complicated Flour (Some complicated, Stuff [Deep Stuff, More Deep Stuff]), Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredients_string = 'Complicated Flour (Some complicated, Stuff (Deep Stuff, More Deep Stuff)), Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end

      it 'sets #description to content' do
        ingredients_string = 'Complicated Flour (Thickener), Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        descriptions = item_ingredients.map(&:description).compact

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.count).to eq 0
        expect(descriptions.count).to eq 1
        expect(descriptions).to eq ['Thickener']
      end
    end

    context 'ingredient string has nested content from "[]" brackets' do
      it 'associated the nested ingredients' do
        ingredients_string = 'Complicated Flour [Some complicated, Stuff], Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredients_string = 'Complicated Flour [Some complicated, Stuff (Deep Stuff, More Deep Stuff)], Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredients_string = 'Complicated Flour [Some complicated, Stuff [Deep Stuff, More Deep Stuff]], Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end


      it 'sets #description to content' do
        ingredients_string = 'Complicated Flour [Thickener], Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        descriptions = item_ingredients.map(&:description).compact

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.count).to eq 0
        expect(descriptions.count).to eq 1
        expect(descriptions).to eq ['Thickener']
      end
    end

    context 'ingredient string contains "and/or"' do
      it 'allows for "and" Ingredients' do
        ingredients_string = 'Complicated Flour and Stuff, Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Stuff', 'Water']
        expect(additional_ingredients.map(&:name)).to eq ['Stuff']
        expect(additional_ingredients.map(&:context)).to eq ['and']
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.count).to eq 0
      end

      it 'allows for "or" Ingredients' do
        ingredients_string = 'Complicated Flour or Stuff, Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Stuff', 'Water']
        expect(additional_ingredients.map(&:name)).to eq ['Stuff']
        expect(additional_ingredients.map(&:context)).to eq ['or']
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.count).to eq 0
      end

      it 'allows for "and/or" Ingredients' do
        ingredients_string = 'Complicated Flour and/or Stuff, Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Stuff', 'Water']
        expect(additional_ingredients.map(&:name)).to eq ['Stuff']
        expect(additional_ingredients.map(&:context)).to eq ['and/or']
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.count).to eq 0
      end

      it 'allows for "from" Ingredients' do
        ingredients_string = 'Complicated Flour from Stuff, Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Stuff', 'Water']
        expect(additional_ingredients.map(&:name)).to eq ['Stuff']
        expect(additional_ingredients.map(&:context)).to eq ['from']
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.count).to eq 0
      end

      it 'allows for multiple "and/or" Ingredients' do
        ingredients_string = 'Complicated Flour or Stuff and Other Stuff, Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Stuff', 'Other Stuff', 'Water']
        expect(additional_ingredients.count).to eq 2
        expect(additional_ingredients.map(&:name)).to eq ['Stuff', 'Other Stuff']
        expect(additional_ingredients.map(&:context)).to eq ['or', 'and']
      end

      it 'allows for multiple "and/or" Ingredients within nested content' do
        ingredients_string = 'Complicated Flour (Stuff and Other Stuff and/or Some Stuff), Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to include 'Complicated Flour',
                                                        'Stuff',
                                                        'Other Stuff',
                                                        'Some Stuff',
                                                        'Water'
        expect(nested_ingredients.count).to eq 1
        expect(nested_ingredients.map(&:name)).to include 'Stuff'
        expect(additional_ingredients.count).to eq 2
        expect(additional_ingredients.map(&:name)).to eq ['Other Stuff', 'Some Stuff']
        expect(additional_ingredients.map(&:context)).to eq ['and', 'and/or']
      end
    end

    context 'when the ingredient has a ":"' do
      it 'sets the @description attribute' do
        ingredients_string = 'Complicated Flour (Something, Contains 1% or less of: Sugar), Water'

        subject.parse(ingredients_string)
        item.reload

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Something', 'Sugar', 'Water']
        expect(nested_ingredients.count).to eq 2
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.map(&:name)).to eq ['Something', 'Sugar']
        expect(item_ingredients.map(&:description).compact).to eq ['Contains 1% or less of']
      end
    end
  end
end
