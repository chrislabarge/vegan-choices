# Item
class Item < ApplicationRecord
  include PathNames
  scope :menu, -> { where(item_type: ItemType.menu) }
  scope :non_menu, -> { where.not(item_type: ItemType.menu) }

  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items

  has_many :item_ingredients, inverse_of: :item
  has_many :ingredients, through: :item_ingredients, source: :ingredient

  validates :name, presence: true

  delegate :name, to: :restaurant, prefix: true
  delegate :path_name, to: :restaurant, prefix: true
  delegate :image_path_suffix, to: :restaurant, prefix: true

  after_save :no_image_file_notification

  def image_path_suffix
    restaurant_image_path_suffix + 'items/'
  end

  def main_item_ingredients
    item_ingredients.main
  end
end
