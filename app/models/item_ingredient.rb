class ItemIngredient < ApplicationRecord
  scope :main, -> { where(parent_id: nil) }
  scope :nested, -> { where(context: nil).where.not(parent_id: nil) }
  scope :additional, -> { where.not(context: nil, parent_id: nil) }

  belongs_to :item, inverse_of: :item_ingredients
  belongs_to :ingredient, inverse_of: :item_ingredients

  has_many :item_ingredients, class_name: 'ItemIngredient',
                              foreign_key: 'parent_id', dependent: :destroy
  has_many :ingredients, through: :item_ingredients, source: :ingredient

  delegate :name, to: :ingredient

  validates :item, presence: true
  validates :ingredient, presence: true

  def additional_item_ingredient
    item_ingredients.additional.first
  end
end
