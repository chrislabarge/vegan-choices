module RestaurantHelper
  def locations_url(restaurant)
    maps_base_url = 'https://www.google.com/maps/search/'
    maps_base_url + restaurant.path_name
  end
  def test(item_ingredient)
    return unless item_ingredient
    if additional_item_ingredient = item_ingredient.item_ingredients.additional.first
      return (additional_item_ingredient.context + (render 'items/item_ingredient', item_ingredient: additional_item_ingredient).to_s).html_safe
    end
    if (nested_ingedients = item_ingredient.item_ingredients.nested) && nested_ingedients.present?
      nested_ingredients.each do |item_ingredient|
        nested += (render 'items/item_ingredient', item_ingredient: item_ingredient).to_s if item_ingredient
      end
      return ('Containing:' + nested).html_safe
    end
  end
end
