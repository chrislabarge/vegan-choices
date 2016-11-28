# Item
class Item < ApplicationRecord
  include PathNames

  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items

  validates :name, presence: true

  delegate :name, to: :restaurant, prefix: true
  delegate :path_name, to: :restaurant, prefix: true
  delegate :image_path_suffix, to: :restaurant, prefix: true

  after_save :no_image_file_notification

  def ingredient_list
    return unless ingredients
    parser = IngredientParser.new
    parser.parse(ingredients)
  end

  def image_path_suffix
    restaurant_image_path_suffix + 'items/'
  end
end
