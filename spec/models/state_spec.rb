require 'rails_helper'

RSpec.describe State, type: :model do
  it { should have_many(:locations).inverse_of(:state) }
end
