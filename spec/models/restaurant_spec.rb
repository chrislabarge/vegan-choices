require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  it { should have_many(:ingredient_lists).inverse_of(:restaurant)}
  it { should have_many(:items).inverse_of(:restaurant)}

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
