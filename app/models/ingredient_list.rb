# frozen_string_literal: true
# Ingredient List
class IngredientList < ApplicationRecord
  belongs_to :restaurant, inverse_of: :ingredient_lists
  validates :path, presence: true
end
