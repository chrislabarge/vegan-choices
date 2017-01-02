# frozen_string_literal: true
# Ingredient Parser
class ItemIngredientParser
  SECTION_REGEX = /(?:\([^\)]*\)|\[[^\]]*\]|[^,])+/
  NESTED_CONTENT_REGEX = /(?<=\(|\[)(?:\(|\[[^()]*\)|\]|[^()])*(?=\)|\])/
  AND_OR_REGEX = / and\/or | and | or | from /i
  PARENTHESES_REGEX = /\((?>[^)(]+|\g<0>)*\)/
  BRACKET_REGEX = /\[(?>[^\]\[]+|\g<0>)*\]/

  def initialize(item)
    @item = item
  end

  def parse(string)
    # TODO: Decide what exactly to return
    generate_item_ingredients_from(string)
  end

  def generate_item_ingredients_from(string)
    existing_item_ingredients = @item.item_ingredients.to_a
    sections = split_into_sections(string).map(&:strip)

    sections.map { |section| new_ingredient_from_section(section) }

    parent_ingredients(existing_item_ingredients)
  end

  def split_into_sections(string)
    string.scan(SECTION_REGEX).map(&:strip)
  end

  def new_ingredient_from_section(section)
    filtered_section = filter(section)

    item_ingredient = initialize_ingredient_from(filtered_section)

    finalize_item_ingredient(item_ingredient)
  end

  def parent_ingredients(existing)
    @item.item_ingredients.to_a - existing
  end

  def filter(string)
    remove_escaped_characters(string)
    remove_unneeded_punctuation(string)
  end

  def remove_escaped_characters(string)
    string.delete("\n") || string
  end

  def remove_unneeded_punctuation(string)
    string.delete '.' || string
  end

  def initialize_ingredient_from(string)
    ingredient = Ingredient.new(name: string)
    item_ingredient = @item.item_ingredients.create(ingredient: ingredient)

    process_nested_content(item_ingredient)
  end

  def process_nested_content(item_ingredient)
    ingredient = item_ingredient.ingredient

    if (nested_content = nested_content_parser(ingredient))
      format_and_set_nested_content(nested_content, item_ingredient)
    end

    item_ingredient
  end

  def nested_content_parser(ingredient)
    return unless (regex = nested_slice_regex(ingredient))

    ingredient.name.slice!(regex)
  end

  def nested_slice_regex(ingredient)
    name = ingredient.name
    parentheses_index = name.index('(')
    bracket_index = name.index('[')

    return nil if bracket_index.nil? && parentheses_index.nil?
    return PARENTHESES_REGEX if parentheses_index && bracket_index.nil?
    return BRACKET_REGEX if bracket_index && parentheses_index.nil?
    return PARENTHESES_REGEX if bracket_index > parentheses_index
    BRACKET_REGEX
  end

  def format_and_set_nested_content(nested_content, item_ingredient)
    nested_content = remove_nest(nested_content)

    if string_contains_a_list?(nested_content)
      nested_ingredients = generate_item_ingredients_from(nested_content)
      nested_ingredients.each { |obj| obj.update(parent_id: item_ingredient.id) }
    else
      item_ingredient.description = nested_content
    end
  end

  def remove_nest(string)
    string[1..-2]
  end

  def string_contains_a_list?(string)
    string.include?(',') || string.scan(AND_OR_REGEX).any?
  end

  def finalize_item_ingredient(item_ingredient)
    item_ingredient = process_description_and_name(item_ingredient)

    process_additional_item_ingredient(item_ingredient)
    finalize_ingredient(item_ingredient)

    item_ingredient.save
  end

  def finalize_ingredient(item_ingredient)
    existing_ingredient = Ingredient.find_by(name: item_ingredient.ingredient.name)

    if existing_ingredient
      item_ingredient.ingredient_id = existing_ingredient.id
    else
      item_ingredient.ingredient.save
    end
  end

  def process_description_and_name(item_ingredient)
    description = parse_description(item_ingredient)
    set_description(item_ingredient, description) if description

    item_ingredient
  end

  def set_description(item_ingredient, description)
    ingredient = item_ingredient.ingredient
    item_ingredient.description = description
    ingredient.name = remove_first_character(ingredient.name).strip
  end

  def parse_description(item_ingredient)
    ingredient = item_ingredient.ingredient
    ingredient.name.strip!
    name = ingredient.name

    return unless name.include?(':')

    name.slice!(/^[^\:]*/)
  end

  def remove_first_character(string)
    string[1..-1].strip
  end

  def process_additional_item_ingredient(item_ingredient)
    return unless ( context = parse_additional_ingredient_context(item_ingredient.name))
    additional_item_ingredient = create_additional_item_ingredient(item_ingredient, context)

    finalize_item_ingredient(additional_item_ingredient) if additional_item_ingredient
  end

  def parse_additional_ingredient_context(string)
    string.slice(AND_OR_REGEX)
  end

  def create_additional_item_ingredient(item_ingredient, context)
    ingredient = item_ingredient.ingredient
    ingredients = ingredient.name.split(context, 2)
    ingredient.name = ingredients[0]

    additional_ingredient = Ingredient.create(name: ingredients[1])
    ItemIngredient.create(item_id: item_ingredient.item.id,
                          parent_id: item_ingredient.id,
                          ingredient: additional_ingredient,
                          context: context.strip)
  end
end
