require 'rails_helper'

RSpec.describe Allergen, type: :model do
  it { should have_many(:item_allergens).inverse_of(:allergen) }
  it { should have_many(:items).through(:item_allergens) }
end
