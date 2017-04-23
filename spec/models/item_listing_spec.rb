require 'rails_helper'

RSpec.describe ItemListing, type: :model do
  it { should belong_to(:restaurant).inverse_of(:item_listings) }
end
