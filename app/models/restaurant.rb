# frozen_string_literal: true
# Restaurant
class Restaurant < ApplicationRecord
  validates :name, presence: true, uniqueness: true
end
