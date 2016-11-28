# frozen_string_literal: true
# Item Type
class ItemType < ApplicationRecord
  BEVERAGE = 'beverage'.freeze
  MENU = 'menu'.freeze
  TOPPING = 'topping'.freeze
  CONDIMENT = 'condiment'.freeze
  BREAD = 'bread'.freeze

  has_many :items, inverse_of: :item_type

  validates :name, presence: true, uniqueness: true

  def self.names
    [BEVERAGE,
     MENU,
     TOPPING,
     CONDIMENT,
     BREAD]
  end

  names.each do |name|
    define_singleton_method name.to_sym do
      find_by(name: name)
    end
  end
end
