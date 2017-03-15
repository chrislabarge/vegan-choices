class Diet < ApplicationRecord
  VEGAN = 'vegan'.freeze
  VEGETARIAN = 'vegetarian'.freeze

  has_many :item_diets, inverse_of: :diet
  has_many :items, through: :item_diets

  validates :name, presence: true, uniqueness: true

  def self.names
    [VEGAN, VEGETARIAN]
  end

  def pertains_to?(string)
    find_exclusion_keywords(string).empty?
  end

  names.each do |name|
    define_singleton_method name.to_sym do
      find_by(name: name)
    end
  end

  private

  def exclusion_regex
    regex = ''

    exclusion_keywords.each do |keyword|
      regex += keyword + (keyword == exclusion_keywords.last ? '' : '|')
    end

    regex
  end

  def find_exclusion_keywords(string)
    string.scan(/#{exclusion_regex}/i)
  end
end
