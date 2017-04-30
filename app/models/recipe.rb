class Recipe < ApplicationRecord
  belongs_to :item, inverse_of: :recipe

  has_many :recipe_items, inverse_of: :recipe, dependent: :destroy
  has_many :items, through: :recipe_items

  validates :item_id, presence:true, uniqueness: true
end
