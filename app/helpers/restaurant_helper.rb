module RestaurantHelper
  def locations_url(restaurant)
    maps_base_url = 'https://www.google.com/maps/search/'
    maps_base_url + restaurant.path_name
  end

  def recipe
    @recipe || nil
  end

  def display_items_by_type_list(items)
    content = ''
    sorted_items_by_scope = sort_by_scope_and_count(items)

    sorted_items_by_scope.each do |scope, items|
      content += render 'items/list_by_scope', scope: scope, items: items
    end

    content.html_safe
  end

  def sort_by_scope_and_count(items)
    scopes = Item.type_scopes

    sorted_items_by_scope = Item.sort_by_scope(items).sort_by do |scope, items|
      scopes -= [scope]
      items.count
    end

    sorted_items_by_scope = format_the_sorted_items(sorted_items_by_scope)

    scopes.each do |scope|
      sorted_items_by_scope << { scope => [] }
    end

    sorted_items_by_scope
  end

  def format_the_sorted_items(sorted_items_by_scope)
    sorted_items_by_scope.reverse!

    sorted_items_by_scope.map do |scope, items|
      [scope, items.sort_by{ |i| i.name }]
    end
  end

  def display_nested_content(item_ingredient)
    item_ingredients = item_ingredient.item_ingredients
    nested_ingredients = item_ingredients.nested.to_a
    additional_item_ingredient = item_ingredient.additional_item_ingredient
    nested_content = ''

    if additional_item_ingredient
      nested_content = generate_additional_item_ingredients_html(additional_item_ingredient)
      nested_ingredients.unshift(additional_item_ingredient) unless nested_content.present?
    end

    if nested_ingredients.present?
      nested_content += generate_nested_ingredients_html(nested_ingredients)
    end

    nested_content.html_safe
  end

  def generate_additional_item_ingredients_html(item_ingredient)
    prefix = item_ingredient.context

    return '' unless inline_item_ingredient?(prefix)

    "<div class='inline'> #{prefix} #{display_item_ingredient_name(item_ingredient)}</div>"
  end

  def generate_nested_ingredients_html(nested_ingredients)
    prefix = 'Containing'
    " #{prefix} " + (render 'items/item_ingredients',
                            item_ingredients: nested_ingredients)
  end

  def inline_item_ingredient?(prefix)
    prefix == 'or' || prefix == 'and/or' || prefix == 'from'
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
    name = item_ingredient.name.upcase.titleize
    url = more_ingredient_info_url(name)
    klass = nil

    if recipe
      item_names = recipe.items.map do |i|
        if (i.name.downcase == name.downcase)
          url = "#"
          klass = 'recipe-item'
          break
        end
      end
    end

    link_to(name, url, class: klass) + display_item_ingredient_description(item_ingredient)
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
