require 'rails_helper'

RSpec.describe ItemIngredientGenerator, type: :model do
  let(:item) { FactoryGirl.create(:item) }
  let(:restaurant) { item.restaurant }

  subject { ItemIngredientGenerator.new(item) }

  describe '#generate' do
    it 'generates ItemIngredient for item' do
      str = 'Flour, Salt'
      allow(item).to receive(:ingredient_string) { str }

      subject.generate

      item.item_ingredients

      actual = item.item_ingredients

      expect(actual.map(&:name)).to eq ['Flour', 'Salt']
    end
  end

  describe '#parse' do
    it 'parses the passed string and returns a collection of ItemIngredients' do
      ingredient_string = 'Flour, Salt'
      allow(item).to receive(:ingredient_string) { ingredient_string }

      collection = subject.generate

      expect(collection.all? { |i| i.class == ItemIngredient }).to eq true

      expect(collection.map(&:name)).to eq ['Flour', 'Salt']
    end

    context 'an ingredient already exists in the database' do
      it 'does not create a new ingredient to associate to the "ItemIngredient"' do
        ingredient_name = 'Complicated Flour'
        Ingredient.create(name: ingredient_name)
        ingredient_string = ingredient_name
        ingredient_count = Ingredient.all.count

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = "#{ingredient_name}, A new Ingredient"
        ingredient_count = Ingredient.all.count

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour (Some complicated, Stuff), Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredient_string = 'Complicated Flour (Some complicated, Stuff [Deep Stuff, More Deep Stuff]), Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredient_string = 'Complicated Flour (Some complicated, Stuff (Deep Stuff, More Deep Stuff)), Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end

      it 'sets #description to content' do
        ingredient_string = 'Complicated Flour (Thickener), Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour [Some complicated, Stuff], Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredient_string = 'Complicated Flour [Some complicated, Stuff (Deep Stuff, More Deep Stuff)], Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end

      it 'associates the multiple nested ingredients' do
        ingredient_string = 'Complicated Flour [Some complicated, Stuff [Deep Stuff, More Deep Stuff]], Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff', 'Water']
        expect(main_ingredients.map(&:name)).to eq ['Complicated Flour', 'Water']
        expect(nested_ingredients.map(&:name)).to eq ['Some complicated', 'Stuff', 'Deep Stuff', 'More Deep Stuff']
      end


      it 'sets #description to content' do
        ingredient_string = 'Complicated Flour [Thickener], Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour and Stuff, Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour or Stuff, Water'

         allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour and/or Stuff, Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour from Stuff, Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour or Stuff and Other Stuff, Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour (Stuff and Other Stuff and/or Some Stuff), Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

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
        ingredient_string = 'Complicated Flour (Something, Contains 1% or less of: Sugar), Water'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expect(item_ingredients.map(&:name)).to eq ['Complicated Flour', 'Something', 'Sugar', 'Water']
        expect(nested_ingredients.count).to eq 2
        expect(main_ingredients.count).to eq 2
        expect(nested_ingredients.map(&:name)).to eq ['Something', 'Sugar']
        expect(item_ingredients.map(&:description).compact).to eq ['Contains 1% or less of:']
      end
    end

    context 'taco bell' do
      it 'sets the @description attribute' do
        ingredient_string = 'Hot sauce (aged cayenne pepper, vinegar, salt, garlic), water, soybean oil, vinegar, salt, contains less than 2% of xanthan gum, polysorbate 60, oleoresin paprika (VC), natural & artificial flavor (milk). '

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expected_ingredient_names = ['Hot sauce', 'aged cayenne pepper', 'vinegar', 'salt', 'garlic',  'water', 'soybean oil', 'vinegar', 'salt', 'xanthan gum', 'polysorbate 60', 'oleoresin paprika', 'natural & artificial flavor']
        actual_ingredient_names = item_ingredients.map(&:name)

        expected_descriptions = ['contains less than 2% of',  "VC", 'milk']
        actual_descriptions = item_ingredients.map(&:description).compact

        expected_nested_ingredient_names = ['aged cayenne pepper',  "vinegar", 'salt', 'garlic']
        actual_nested_ingredient_names = nested_ingredients.map(&:name)


        expected_ingredient_names.each do |ingredient_name|
          expect(actual_ingredient_names).to include ingredient_name
        end

        expected_descriptions.each do |description|
          expect(actual_descriptions).to include description
        end

        expected_nested_ingredient_names.each do |nested_ingredient_name|
          expect(actual_nested_ingredient_names).to include nested_ingredient_name
        end
      end
    end

    context 'taco bell' do
      it 'sets the @description attribute' do
        ingredient_string = 'Chicken, water, soy protein concentrate, salt, sodium phosphates. Battered and breaded with: wheat flour, water, leavening (sodium bicarbonate, sodium acid pyrophosphate), flavor, egg whites. Breading set in vegetable oil'

        allow(item).to receive(:ingredient_string) { ingredient_string }

        subject.generate

        item_ingredients = item.item_ingredients
        main_ingredients = item.main_item_ingredients
        nested_ingredients = ItemIngredient.nested
        additional_ingredients = ItemIngredient.additional

        expected_ingredient_names = ['Chicken',
                                     'water',
                                     'soy protein concentrate',
                                     'salt',
                                     'sodium phosphates',
                                     'wheat flour',
                                     'leavening',
                                     'sodium bicarbonate',
                                     'sodium acid pyrophosphate',
                                     'flavor',
                                     'egg whites',
                                     'Breading set in vegetable oil']

        actual_ingredient_names = item_ingredients.map(&:name)

        expected_descriptions = ['Battered and breaded with:']
        actual_descriptions = item_ingredients.map(&:description).compact

        expected_nested_ingredient_names = ['sodium bicarbonate', 'sodium acid pyrophosphate']
        actual_nested_ingredient_names = nested_ingredients.map(&:name)


        expected_ingredient_names.each do |ingredient_name|
          expect(actual_ingredient_names).to include ingredient_name
        end

        expected_descriptions.each do |description|
          expect(actual_descriptions).to include description
        end

        expected_nested_ingredient_names.each do |nested_ingredient_name|
          expect(actual_nested_ingredient_names).to include nested_ingredient_name
        end
      end
    end
  end
end
