# frozen_string_literal: true
# Restaurant
class Restaurant < ApplicationRecord
  include PathNames

  has_many :ingredient_lists, inverse_of: :restaurant
  has_many :items, inverse_of: :restaurant

  validates :name, presence: true, uniqueness: true

  after_create :create_img_dir

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

  private

  def create_img_dir
    directory_name = "app/assets/images/restaurants/#{path_name}"
    Dir.mkdir(directory_name) unless File.directory?(directory_name)
  end
end
