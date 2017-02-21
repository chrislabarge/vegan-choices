class ItemDiet  < ApplicationRecord
  belongs_to :item, inverse_of: :item_diets
  belongs_to :diet, inverse_of: :item_diets

  def self.find_applicable_diets_for_item(item)
    diets = Diet.all

    diets.select { |diet| item_dietary_values_applicable_for_diet?(item, diet) }
  end

  def self.item_dietary_values_applicable_for_diet?(item, diet)
    item.dietary_attributes.each do |attr|
      string = item.send(attr)

      return false unless string.nil? || diet.pertains_to?(string)
    end

    true
  end
end
