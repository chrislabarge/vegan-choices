# frozen_string_literal: true
# Restaurant
class Restaurant < ApplicationRecord
  has_many :ingredient_lists, inverse_of: :restaurant

  validates :name, presence: true, uniqueness: true
end
