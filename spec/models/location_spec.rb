require 'rails_helper'

RSpec.describe Location, type: :model do
  it { should belong_to(:state).inverse_of(:locations) }
  it { should have_many(:restaurants).inverse_of(:location) }

  it { should validate_uniqueness_of(:city).scoped_to(:state_id).case_insensitive }
end
