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
    dropdown_toggle = ''
    additional_item_ingredient = item_ingredient.item_ingredients.additional.first

    return '' unless additional_item_ingredient

    render_content_from(additional_item_ingredient)
  end

  def render_content_from(additional_item_ingredient)
    prefix = additional_item_ingredient.context
    render_options = { item_ingredient: additional_item_ingredient }
    show_prefix = nil


    if prefix == 'or' || prefix == 'and/or' || prefix == 'from'
      show_prefix = true
      render_options[:inline] = true
    else
      render_options[:item] = true
    end

    html = (render 'items/item_ingredient', render_options).to_s

    show_prefix ? (prefix + html) : html
  end

  def nested_ingredient_content(item_ingredient)
    item_ingredients = item_ingredient.item_ingredients
    nested_ingredients = item_ingredients.nested
    nested_content = ''

    return nested_content unless nested_ingredients.present?

    nested_ingredients.each do |nested_item_ingredient|
      next unless item_ingredient
      nested_content += (render 'items/item_ingredient',
                                item_ingredient: nested_item_ingredient,
                                nested: true).to_s
    end

    'Containing:' + nested_content
  end

  def item_ingredient_class(nested, inline, item)
    return 'inline' if inline
    return 'nested-ingredient' if nested
    return 'item' if item

    ' '
  end

  def header_description(item_ingredient)
    description = item_ingredient.description

    return unless description && header?(description)

    render 'items/header_description', description: description
  end

  def header?(str)
    str.scan(/with|%/).present?
  end

  def display_item_ingredient(item_ingredient)
    return unless item_ingredient

    render 'items/item_ingredient', item_ingredient: item_ingredient
  end

  def display_item_ingredient_name(item_ingredient)
    name = item_ingredient.name
    url = more_ingredient_info_url(name)

    link_to name, url
  end

  def more_ingredient_info_url(str)
    endpoint = str.downcase.tr(' ', '_')

    "https://en.wikipedia.org/wiki/#{endpoint}"
  end

  def display_item_ingredient_description(item_ingredient)
    description = item_ingredient.description

    return unless description && !header?(description)

    "(#{description})"
  end
end
