# Item
class Item < ApplicationRecord
  BEVERAGE_UNIQUENESS_REGEX = /(\(\d.*oz\)|\d+ fl oz|large|child|medium|small)/i
  BEVERAGE_UNIQUENESS_ERROR_MSG = 'Beverage already exisits in a different size. Only one size needed.'

  include PathNames

  scope :non_menu, -> { where.not(item_type: ItemType.menu) }
  ItemType.names.each { |type| scope type.to_sym, -> { where(item_type: ItemType.send(type) ) } }
  Diet.names.each { |diet| scope diet.to_sym, -> { includes(:item_diets).where(item_diets: { diet: Diet.send(diet) }) }  }

  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items, optional: true
  belongs_to :user, inverse_of: :items

  has_many :item_diets, inverse_of: :item, dependent: :destroy
  has_many :content_berries, inverse_of: :item, dependent: :destroy
  has_many :recipe_items, inverse_of: :item, dependent: :destroy
  has_many :diets, through: :item_diets
  has_many :item_ingredients, inverse_of: :item, dependent: :destroy
  has_many :ingredients, through: :item_ingredients, source: :ingredient
  has_many :item_allergens, inverse_of: :item, dependent: :destroy
  has_many :allergens, through: :item_allergens
  has_many :item_comments, inverse_of: :item
  has_many :comments, through: :item_comments
  has_many :favorites, inverse_of: :item, dependent: :destroy

  has_one :recipe, inverse_of: :item, dependent: :destroy
  has_one :report_item, dependent: :destroy

  scope :report_items, -> { joins(:report_item) }


  validates :name, presence: true, uniqueness: { scope: :restaurant_id,
                                                   case_sensitive: false }
  validate :beverage_uniqueness_to_size

  delegate :name, to: :restaurant, prefix: true
  delegate :name, to: :item_type, prefix: 'type', allow_nil: true
  delegate :path_name, to: :restaurant, prefix: true
  delegate :image_path_suffix, to: :restaurant, prefix: true, allow_nil: true

  alias_method :type, :item_type

  before_save :init
  before_save :process_item_diets, if: :any_dietary_changes?
  after_save :no_image_file_notification

  accepts_nested_attributes_for :item_diets

  def init
    self.item_type ||= ItemType.other
  end

  def self.sort_by_scope(items)
    items_by_scope = {}

    Item.type_scopes.each do |scope|
      items_by_scope[scope] = items.send(scope)
    end

    items_by_scope
  end

  def self.type_scopes
    ItemType.names.map(&:to_sym) << :other
  end

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
    [:allergen_string,
     :ingredient_string,
     :name]
  end

  def generate_item_ingredients
    return unless ingredient_string.present?

    generator = ItemIngredientGenerator.new(self)
    generator.generate
  end

  def generate_item_allergens
    return unless allergen_string.present?

    generator = ItemAllergenGenerator.new(self)
    generator.generate
  end

  private

  def process_item_diets
    generator = ItemDietGenerator.new(self)
    self.item_diets = generator.generate
  end

  def beverage_uniqueness_to_size
    return unless beverage_exists?

    errors.add :name, BEVERAGE_UNIQUENESS_ERROR_MSG
  end

  def find_beverage_uniqueness_matches
    return unless name && restaurant

    matches = name.scan(BEVERAGE_UNIQUENESS_REGEX).flatten

    matches.present? ? matches : nil
  end

  def beverage_exists?
    return unless (name = beverage_name)
    restaurant.items.where("name like ?", "%#{name}%").present?
  end

  def beverage_name
    regex_matches = find_beverage_uniqueness_matches
    return unless regex_matches.present?

    size = regex_matches[0]
    name.remove(size).remove('()')
  end
end
