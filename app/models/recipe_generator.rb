class RecipeGenerator

  def initialize(restaurant = nil)
    @restaurant = restaurant
    @items = @restaurant.items if restaurant
  end

  def generate(item = nil)
    @item = item
    @recipe = @item.build_recipe

    reinitialize unless @restaurant
    @recipe.save if build_recipe_items.present?
  end

  def reinitialize
    initialize @item.restaurant
  end

  private

  def build_recipe_items
    return unless (ingredient_string = @item.ingredient_string.try(:downcase))

    recipe_items = @items.map do |item|
      next unless (name = item.name.try(:downcase))
      build_recipe_item(item) if ingredient_string.include?(name)
    end

    recipe_items.compact
  end

  def build_recipe_item(item)
    @recipe.recipe_items.new(item: item)
  end
end
