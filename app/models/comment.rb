class Comment < ApplicationRecord
  belongs_to :user, inverse_of: :comments
  belongs_to :item, inverse_of: :comments

  has_one :item_comment, inverse_of: :comment
end
