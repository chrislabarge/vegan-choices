# frozen_string_literal: true
# ItemType
class ItemType < ApplicationRecord
  BEVERAGE = 'beverage'.freeze
  MENU = 'menu'.freeze
  TOPPING = 'topping'.freeze
  CONDIMENT = 'condiment'.freeze
  DESSERT = 'dessert'.freeze
  OTHER = 'other'.freeze

  has_many :items, inverse_of: :item_type

  validates :name, presence: true, uniqueness: true

  def self.names
    [BEVERAGE,
     MENU,
     TOPPING,
     CONDIMENT,
     DESSERT,
     OTHER]
  end

  names.each do |name|
    define_singleton_method name.to_sym do
      find_by(name: name)
    end
  end

  def display_name
    self.name = 'menu item' if self.name == MENU
    self.name.titleize
  end
end
