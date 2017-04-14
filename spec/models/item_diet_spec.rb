require 'rails_helper'

RSpec.describe ItemDiet, type: :model do
  it { should belong_to(:item).inverse_of(:item_diets) }
  it { should belong_to(:diet).inverse_of(:item_diets) }
end
