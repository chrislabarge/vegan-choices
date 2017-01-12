module RestaurantHelper
  def locations_url(restaurant)
    maps_base_url = 'https://www.google.com/maps/search/'
    maps_base_url + restaurant.path_name
  end

  def test(item_ingredient)
    content = ''
    content additional_ingredient_content
    # if additional_item_ingredient = item_ingredient.item_ingredients.additional.first
    #   return (additional_item_ingredient.context + (render 'items/item_ingredient', item_ingredient: additional_item_ingredient).to_s)#.html_safe
    # end

    # nested_ingedients = item_ingredient.item_ingredients.nested

    # if nested_ingedients.present?
    #   nested_ingredients.each do |item_ingredient|
    #     nested += (render 'items/item_ingredient', item_ingredient: item_ingredient).to_s if item_ingredient
    #   end
    #   content += ('Containing:' + nested)#.html_safe
    # end

    content += nested_ingredient_content
    content.html_safe
  end

  def additional_ingredient_content(item_ingredient)
    return '' unless additional_item_ingredient = item_ingredient.item_ingredients.additional.first
    additional_item_ingredient.context + (render 'items/item_ingredient', item_ingredient: additional_item_ingredient).to_s)
    #.html_safe
  end

  def nested_ingredient_content
    nested_ingedients = item_ingredient.item_ingredients.nested
    nested_content = ''

    return nested_content unless nested_ingedients.present?

    nested_ingredients.each do |item_ingredient|
      nested_content += (render 'items/item_ingredient', item_ingredient: item_ingredient).to_s if item_ingredient
    end

    ('Containing:' + nested_content)#.html_safe
  end
end


# divide these up into several functions
# string them all together
