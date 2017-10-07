require 'rails_helper'

RSpec.describe ItemComment, type: :model do
  it { should belong_to(:item).inverse_of(:item_comments) }
  it { should belong_to(:comment) }
  it { should have_one(:user).through(:comment) }
end
