require 'rails_helper'

RSpec.describe ItemAllergen, type: :model do
  it { should belong_to(:item).inverse_of(:item_allergens) }
  it { should belong_to(:allergen).inverse_of(:item_allergens) }
end
