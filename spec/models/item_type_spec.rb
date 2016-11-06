require 'rails_helper'

RSpec.describe ItemType, type: :model do
  it { should have_many(:items).inverse_of(:item_type)}

  it { should validate_presence_of(:name) }
  it { should validate_uniqueness_of(:name) }
end
