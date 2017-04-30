require 'rails_helper'

RSpec.describe Recipe, type: :model do
  it { should belong_to(:item).inverse_of(:recipe) }
  it { should have_many(:recipe_items).inverse_of(:recipe) }
  it { should have_many(:items).through(:recipe_items) }

  it { should validate_presence_of(:item_id) }
end
