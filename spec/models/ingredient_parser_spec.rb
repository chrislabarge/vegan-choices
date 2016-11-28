require 'rails_helper'

RSpec.describe IngredientParser, type: :model do
  # subject { IngredientParser.new('Some Name') }

  describe '#parse' do
    let(:ingredients_string) { 'A Ingredient, Another Ingredient' }

    it 'parses the passed string and returns a list of instances' do
      list = IngredientParser.new().parse(ingredients_string)

      expect(list.map(&:class)).to eq [Ingredient, Ingredient]
      expect(list.map(&:name)).to eq ['A Ingredient', 'Another Ingredient']
    end


    context 'ingredient string has nested content from "()" pathenthese' do
      it 'sets @nested to content' do
        ingredients_string = 'Complicated Flour (Some complicated, Stuff), Water'

        list = IngredientParser.new().parse(ingredients_string)
        nested = list.map(&:nested).flatten.compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested.count).to eq 2
        expect(nested.map(&:name)).to eq ['Some complicated', 'Stuff']
      end

      it 'sets @description to content' do
        ingredients_string = 'Complicated Flour (Thickener), Water'


        list = IngredientParser.new().parse(ingredients_string)
        descriptions = list.map(&:description).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(descriptions.count).to eq 1
        expect(descriptions.last).to eq 'Thickener'
      end
    end

    context 'ingredient string has nested content from "[]" brackets' do
      it 'sets @nested to content' do
        ingredients_string = 'Complicated Flour [Some complicated, Stuff], Water'

        list = IngredientParser.new().parse(ingredients_string)
        nested = list.map(&:nested).flatten.compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested.count).to eq 2
        expect(nested.map(&:name)).to eq ['Some complicated', 'Stuff']
      end

      it 'sets @description to content' do
        ingredients_string = 'Complicated Flour [Thickener], Water'

        list = IngredientParser.new().parse(ingredients_string)
        descriptions = list.map(&:description).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(descriptions.count).to eq 1
        expect(descriptions.last).to eq 'Thickener'
      end
    end

    context 'ingredient string contains "and/or"' do
      it 'allows for "and" Ingredients' do
        ingredients_string = 'Complicated Flour and Stuff, Water'

        list = IngredientParser.new().parse(ingredients_string)
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'and'
      end

      it 'allows for "or" Ingredients' do
        ingredients_string = 'Complicated Flour or Stuff, Water'

        list = IngredientParser.new().parse(ingredients_string)
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'or'
      end

      it 'allows for "and/or" Ingredients' do
        ingredients_string = 'Complicated Flour and/or Stuff, Water'

        list = IngredientParser.new().parse(ingredients_string)
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'and/or'
      end

      it 'allows for "from" Ingredients' do
        ingredients_string = 'Complicated Flour from Stuff, Water'

        list = IngredientParser.new().parse(ingredients_string)


        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'from'
      end

      it 'allows for multiple "and/or" Ingredients' do
        ingredients_string = 'Complicated Flour or Stuff and Other Stuff, Water'

        list = IngredientParser.new().parse(ingredients_string)
        and_or_ingredients = list.map(&:and_or).compact

        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(and_or_ingredients.count).to eq 1
        expect(and_or_ingredients.last.name).to eq 'Stuff'
        expect(and_or_ingredients.last.context).to eq 'or'
        expect(and_or_ingredients.last.and_or.name).to eq 'Other Stuff'
        expect(and_or_ingredients.last.and_or.context).to eq 'and'
      end

      it 'allows for multiple "and/or" Ingredients within nested content' do
        ingredients_string = 'Complicated Flour(Stuff and Other Stuff and/or Some Stuff), Water'

        list = IngredientParser.new().parse(ingredients_string)
        nested_ingredients = list.map(&:nested).flatten.compact
        nested_and_or_ingredients = nested_ingredients.map(&:and_or).compact


        expect(list.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.count).to eq 1
        expect(nested_ingredients.last.name).to eq 'Stuff'
        expect(nested_and_or_ingredients.count).to eq 1
        expect(nested_and_or_ingredients.last.name).to eq 'Other Stuff'
        expect(nested_and_or_ingredients.last.context).to eq 'and'
        expect(nested_and_or_ingredients.last.and_or.name).to eq 'Some Stuff'
        expect(nested_and_or_ingredients.last.and_or.context).to eq 'and/or'
      end
    end

    context 'when the ingredient has a ":"' do
      it 'sets the @description attribute' do
        ingredients_string = 'Complicated Flour (Something, Contains 1% or less of: Sugar), Water'

        list = IngredientParser.new().parse(ingredients_string)
        nested_ingredients = list.map(&:nested).flatten.compact

        descriptions = nested_ingredients.map(&:description).compact

        expect(nested_ingredients.map(&:name)).to eq ['Something', 'Sugar']
        expect(descriptions.count).to eq 1
        expect(descriptions.last).to eq 'Contains 1% or less of'
      end
    end
  end
end
