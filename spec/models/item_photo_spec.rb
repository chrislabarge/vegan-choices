require 'rails_helper'

RSpec.describe ItemPhoto, type: :model do
  it { should belong_to(:item).inverse_of(:item_photos) }
  it { should belong_to(:user).inverse_of(:item_photos) }
end
