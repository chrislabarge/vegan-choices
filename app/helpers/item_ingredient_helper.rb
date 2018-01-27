module ItemIngredientHelper
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


  def display_item_ingredient(item_ingredient)
    return unless item_ingredient

    render 'items/item_ingredient', item_ingredient: item_ingredient
  end

  def display_item_ingredient_name(item_ingredient)
    name = item_ingredient.name
    klass = nil

    if recipe
      item_names = recipe.items.map do |i|
        next unless i.name.casecmp(name.downcase).zero?
        url = '#'
        klass = 'recipe-item'
        break
      end
    end

    link_to(name, '#', class: klass) + display_item_ingredient_description(item_ingredient)
  end

  def more_ingredient_info_url(str)
    endpoint = str.downcase.tr(' ', '_')

    "https://en.wikipedia.org/wiki/#{endpoint}"
  end

  def display_item_ingredient_description(item_ingredient)
    description = item_ingredient.description

    return unless description && normal_description?(description)

    "(#{description})"
  end

  def normal_description?(str)
    !header?(str) && str.scan(/due.*contains/i).empty?
  end
end
