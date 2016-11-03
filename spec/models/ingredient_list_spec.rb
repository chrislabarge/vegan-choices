require 'rails_helper'

RSpec.describe IngredientList, type: :model do
  it { should belong_to(:restaurant).inverse_of(:ingredient_lists) }
  it { should validate_presence_of(:path) }
end
