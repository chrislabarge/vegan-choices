# Item
class Item < ApplicationRecord
  include PathNames

  scope :non_menu, -> { where.not(item_type: ItemType.menu) }
  scope :other, -> { where(item_type: nil) }
  ItemType.names.each { |type| scope type.to_sym, -> { where(item_type: ItemType.send(type) ) } }
  Diet.names.each { |diet| scope diet.to_sym, -> { includes(:item_diets).where(item_diets: { diet: Diet.send(diet) }) }  }

  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items, optional: true

  has_many :item_diets, inverse_of: :item, dependent: :destroy
  has_many :diets, through: :item_diets
  has_many :item_ingredients, inverse_of: :item, dependent: :destroy
  has_many :ingredients, through: :item_ingredients, source: :ingredient

  validates :name, presence: true, uniqueness: { scope: :restaurant_id,
                                                 case_sensitive: false }

  delegate :name, to: :restaurant, prefix: true
  delegate :path_name, to: :restaurant, prefix: true
  delegate :image_path_suffix, to: :restaurant, prefix: true, allow_nil: true

  before_save :process_item_diets, if: :any_dietary_changes?
  after_save :no_image_file_notification

  def image_path_suffix
    "#{restaurant_image_path_suffix}items/"
  end

  def main_item_ingredients
    item_ingredients.main
  end

  def any_dietary_changes?
    dietary_attributes.each { |attr| return true if send("#{attr}_changed?") }

    false
  end

  def dietary_attributes
    [:allergens,
     :ingredient_string,
     :name]
  end

  private

  def process_item_diets
    generator = ItemDietGenerator.new(self)
    self.item_diets = generator.generate
  end
end
