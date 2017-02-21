require 'rails_helper'

RSpec.describe ItemDiet, type: :model do
  it { should belong_to(:item).inverse_of(:item_diets) }
  it { should belong_to(:diet).inverse_of(:item_diets) }


  describe '.find_applicable_diets' do
    let(:diet) { Diet.create(name: 'a diet') }
    let(:item) { FactoryGirl.build_stubbed(:item) }

    before do
      diet
      allow_any_instance_of(Diet).to receive(:pertains_to?) { true }
    end

    context 'when an items dietarty attributes pertain to diet' do
      it 'returns a list including the diet' do

        actual = ItemDiet.find_applicable_diets_for_item(item)

        expect(actual).to include diet
      end
    end

    context 'when an items allergens do NOT pertain to diet' do
      it 'returns an empty array' do
        allow_any_instance_of(Diet).to receive(:pertains_to?).with(item.allergens) { false }

        actual = ItemDiet.find_applicable_diets_for_item(item)

        expect(actual.empty?).to eq true
      end
    end

    context 'when an items name do NOT pertain to diet' do
      it 'returns an empty array' do
        allow_any_instance_of(Diet).to receive(:pertains_to?).with(item.name) { false }

        actual = ItemDiet.find_applicable_diets_for_item(item)

        expect(actual.empty?).to eq true
      end
    end

    context 'when an items name do NOT pertain to diet' do
      it 'returns an empty array' do
        allow_any_instance_of(Diet).to receive(:pertains_to?).with(item.ingredient_string) { false }

        actual = ItemDiet.find_applicable_diets_for_item(item)

        expect(actual.empty?).to eq true
      end
    end
  end
end
