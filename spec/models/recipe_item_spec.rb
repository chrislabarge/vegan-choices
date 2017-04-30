require 'rails_helper'

RSpec.describe RecipeItem, type: :model do
  it { should belong_to(:item).inverse_of(:recipe_items) }
  it { should belong_to(:recipe).inverse_of(:recipe_items) }

  it { should validate_presence_of(:item_id) }
end

