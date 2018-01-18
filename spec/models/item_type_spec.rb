require 'rails_helper'

RSpec.describe ItemType, type: :model do
  it { should have_many(:items).inverse_of(:item_type)}

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }

  # test_dynamic_defintion_of_class_methods
  ItemType.names.each do |name|
    describe ".#{name}" do
      context 'when type exists' do
        it 'returns an instance of the item type' do
          item_type = FactoryBot.create(:item_type, name: name)

          actual = ItemType.send(name)

          expect(actual).to eq item_type
        end
      end

      context 'when there type does NOT exist' do
        it 'returns nil' do
          actual = ItemType.send(name)

          expect(actual).to eq nil
        end
      end
    end
  end
end
