class Recipe < ApplicationRecord
  belongs_to :item, inverse_of: :recipe

  has_many :recipe_items, inverse_of: :recipe, dependent: :destroy
  has_many :items, through: :recipe_items
  has_many :recipe_item_diets, through: :recipe_items, source: :diets

  validates :item_id, presence:true, uniqueness: true

  after_commit :process_item_diets

  def diets
    all_diets = recipe_item_diets

    recipe_items.each do |ri|
      non_pertainable_diets = all_diets - ri.diets
      all_diets -= non_pertainable_diets
    end

    all_diets
  end

  def process_item_diets
    item.send(:process_item_diets)
  end
end
