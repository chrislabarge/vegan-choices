module RestaurantHelper
  def locations_url(restaurant)
    maps_base_url = 'https://www.google.com/maps/search/'
    maps_base_url + restaurant.path_name
  end

  def render_item_ingredient(item_ingredient)
    content = ''

    content_methods.each do |method|
      content += send(method, item_ingredient)
    end

    content.html_safe
  end

  def content_methods
    [:additional_ingredient_content, :nested_ingredient_content]
  end

  def additional_ingredient_content(item_ingredient)
    additional_item_ingredient = item_ingredient.item_ingredients.additional.first

    return '' unless additional_item_ingredient

    prefix = additional_item_ingredient.context

    dropdown_toggle = "<button class='toggle-nested-ingredients'>#{prefix}</button>"

    dropdown_toggle + (render 'items/item_ingredient',
                     item_ingredient: additional_item_ingredient, nested: true).to_s
  end

  # TODO: This should be refactored. THE LINE COUNT IS TOO DAMN HIGH!!
  def nested_ingredient_content(item_ingredient)
    item_ingredients = item_ingredient.item_ingredients
    nested_ingredients = item_ingredients.nested
    nested_content = ''

    return nested_content unless nested_ingredients.present?

    nested_ingredients.each do |nested_item_ingredient|
      next unless item_ingredient
      nested_content += (render 'items/item_ingredient',
                                item_ingredient: nested_item_ingredient).to_s
    end

    'Containing:' + nested_content
  end
end
