require 'rails_helper'

RSpec.describe Report, type: :model do
  it { should belong_to(:user).inverse_of(:reports) }
end
