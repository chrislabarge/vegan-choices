require 'rails_helper'

RSpec.describe Diet, type: :model do
  it { should have_many(:item_diets).inverse_of(:diet) }
  it { should have_many(:items).through(:item_diets) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  describe '#pertains_to?' do
    let(:diet) { Diet.new(name: 'Diet') }
    let(:string) { 'foo' }

    context 'returns true when' do
      it 'receives a string that does NOT include an exclusion keyword' do
        allow(diet).to receive(:find_exclusion_keywords).with(string) { [] }

        actual = diet.pertains_to?(string)

        expect(actual).to eq true
      end
    end

    context 'returns false when' do
      it 'receives a string that does include an exclusion keyword' do
        allow(diet).to receive(:find_exclusion_keywords).with(string) { [string] }

        actual = diet.pertains_to?(string)

        expect(actual).to eq false
      end
    end
  end
end
