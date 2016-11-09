# Item
class Item < ApplicationRecord
  include PathNames

  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items

  validates :name, presence: true

  delegate :name, to: :restaurant, prefix: true
  delegate :path_name, to: :restaurant, prefix: true

  def ingredient_list
    return ingredients.scan(/(?:\([^()]*\)|[^,])+/).map(&:strip) if ingredients
    nil
  end

  def image_path
    path_prefix = "app/assets/images/restaurants/#{restaurant_path_name}/items/#{path_name}*"
    Dir[path_prefix].first.sub('app/assets/images/', '')
  end
end
