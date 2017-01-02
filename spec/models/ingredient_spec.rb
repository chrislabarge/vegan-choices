require 'rails_helper'

RSpec.describe Ingredient, type: :model do
  it { should have_many(:item_ingredients).inverse_of(:ingredient) }
  it { should have_many(:items).through(:item_ingredients) }

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
