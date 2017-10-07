require 'rails_helper'

RSpec.describe Comment, type: :model do
  it { should belong_to(:user).inverse_of(:comments) }
  it { should have_one(:item_comment).inverse_of(:comment) }
end
