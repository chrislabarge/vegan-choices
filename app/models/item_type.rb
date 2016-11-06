# frozen_string_literal: true
# Item Type
class ItemType < ApplicationRecord
  BEVERAGE = 'beverage'
  MENU = 'menu'
  TOPPING = 'topping'
  CONDIMENT = 'condiment'
  BREAD = 'bread'

  has_many :items, inverse_of: :item_type

  validates :name, presence: true, uniqueness: true

  def self.names
    [BEVERAGE,
     MENU,
     TOPPING,
     CONDIMENT,
     BREAD]
  end
end
