require 'rails_helper'

RSpec.describe ItemDietGenerator, type: :model do
  subject { ItemDietGenerator }
  describe '#generate' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    let(:diet) { FactoryGirl.create(:diet, name: Diet::VEGAN) }

    before do
      diet
    end

    context 'when an item is certified' do
      it 'it generates item diets' do
        certification = 'Apples, Certified Vegan'
        allow(item).to receive(:ingredient_string) { certification }

        generator = subject.new(item)

        actual = generator.generate

        expect(actual.select(&:certified).map(&:diet)).to include diet
      end
    end

    context 'when an item is applicaple to a diet' do
      it 'it generates item diets' do

        generator = subject.new(item)

        allow(generator).to receive(:find_applicable_diets_for_item) { [diet] }

        actual = generator.generate

        expect(actual.map(&:diet)).to include diet
      end
    end

    context 'when an item diet already exits' do
      let(:item_diet) { FactoryGirl.create(:item_diet, diet: diet) }
      let(:item) { item_diet.item }

      it 'does not generate a new ItemDiet when it is certified' do
        certification = 'Apples, Certified Vegan'
        allow(item).to receive(:ingredient_string) { certification }
        item_diet_count = ItemDiet.all.count

        generator = subject.new(item)
        actual = generator.generate

        expect(actual.count).to eq item_diet_count
        expect(actual).to include item_diet
      end

      it 'does not generate a new ItemDiet when it is applicaple' do
        generator = subject.new(item)
        item_diets_count = ItemDiet.all.count
        allow(generator).to receive(:find_applicable_diets_for_item) { [diet] }

        actual = generator.generate

        expect(actual.count).to eq item_diets_count
        expect(actual).to include item_diet
      end
    end
  end


  describe '#find_applicable_diets_for_item' do
    let(:item) { FactoryGirl.build_stubbed(:item) }
    let(:diet) { Diet.create(name: 'a diet') }
    let(:diets) { [diet] }
    let(:generator) { subject.new(item) }


    before do
      diet
      allow_any_instance_of(Diet).to receive(:pertains_to?) { true }
    end

    context 'when an items dietarty attributes pertain to diet' do
      it 'returns a list including the diet' do
        actual = generator.find_applicable_diets_for_item(diets)
        expect(actual).to include diet
      end
    end

    context 'when an items allergens do NOT pertain to diet' do
      it 'returns an empty array' do
        allow_any_instance_of(Diet).to receive(:pertains_to?).with(item.allergens) { false }

        actual = generator.find_applicable_diets_for_item(diets)

        expect(actual.empty?).to eq true
      end
    end

    context 'when an items name do NOT pertain to diet' do
      it 'returns an empty array' do
        allow_any_instance_of(Diet).to receive(:pertains_to?).with(item.name) { false }

        actual = generator.find_applicable_diets_for_item(diets)

        expect(diet).to have_received(:pertains_to?).with(item.name)
        expect(actual.empty?).to eq true
      end
    end


    context 'when an items ingredient_string do NOT pertain to diet' do
      it 'returns an empty array' do
        allow_any_instance_of(Diet).to receive(:pertains_to?).with(item.ingredient_string) { false }

        actual = generator.find_applicable_diets_for_item(diets)

        expect(actual.empty?).to eq true
      end
    end
  end

  describe 'certifying item diets' do
    context 'when a diet is certified in #ingredient_string' do
      it 'it certifies the ItemDiet' do
        certification = 'Apples, Certified Vegan'
        item = FactoryGirl.build(:item, ingredient_string: certification)
        diet = FactoryGirl.create(:diet, name: Diet::VEGAN)

        item.save
        item.reload

        item_diets = item.item_diets

        expect(item_diets.select(&:certified).map(&:diet)).to include diet
      end
    end

    context 'when a diet is certified in #allergens' do
      it 'it certifies the ItemDiet' do
        certification = 'Apples, Certified Vegan'
        item = FactoryGirl.build(:item, allergens: certification)
        diet = FactoryGirl.create(:diet, name: Diet::VEGAN)

        item.save

        item_diets = item.item_diets

        expect(item_diets.select(&:certified).map(&:diet)).to include diet
      end
    end
  end

  describe 'item with a recipe' do
    let(:item_diet) { FactoryGirl.create(:item_diet) }
    let(:diet) { item_diet.diet }
    let(:recipe_item) { FactoryGirl.create(:recipe_item, item: item_diet.item) }
    let(:recipe) { recipe_item.recipe }
    let(:item_with_recipe) { recipe.item }
    let(:generator) { subject.new(item_with_recipe) }

    it 'generates a ItemDiet when the diet is included in each recipe item' do
      allow(generator).to receive(:item_dietary_values_applicable_for_diet?) { true }

      actual = generator.generate

      expect(actual.present?).to eq true
      expect(actual.map(&:diet)).to include diet
    end

    it 'does not generate a ItemDiet when the diet is not included in each recipe item' do
      allow(generator).to receive(:item_dietary_values_applicable_for_diet?) { true }
      allow(recipe).to receive(:diets) { [] }

      actual = generator.generate

      expect(actual.map(&:diet)).not_to include diet
      expect(actual).to be_empty
    end
  end
end
