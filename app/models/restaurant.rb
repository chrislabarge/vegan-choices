# frozen_string_literal: true
# Restaurant
class Restaurant < ApplicationRecord
  has_many :ingredient_lists, inverse_of: :restaurant
  has_many :items, inverse_of: :restaurant

  validates :name, presence: true, uniqueness: true

  def items_mapped_by_type(item_types = nil)
    item_types ||= ItemType.all
    hash = {}

    item_types.each do |type|
      hash[type] = items_by_type(type)
    end

    hash
  end

  def items_by_type(type)
    items.where(item_type: type)
  end
end
