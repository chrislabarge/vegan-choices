# frozen_string_literal: true
# Ingredient Parser
class IngredientParser
  SECTION_REGEX = /(?:\([^()]*\)|\[[^\()]*\]|[^,])+/
  NESTED_CONTENT_REGEX = /(?<=\(|\[)(?:\(|\[[^()]*\)|\]|[^()])*(?=\)|\])/
  AND_OR_REGEX = / and\/or | and | or | from /i

  def parse(string)
    sections = split_into_sections(string).map(&:strip)

    sections.map { |section| new_ingredient_from_section(section) }
  end

  def split_into_sections(string)
    # split by comma, excluding nested content (content inbetween '()' or '[]')
    string.scan(SECTION_REGEX).map(&:strip)
  end

  def new_ingredient_from_section(section)
    filtered_section = filter(section)

    ingredient = initialize_ingredient_from(filtered_section)

    finalize_ingredient(ingredient)
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
    ingredient = Ingredient.new(string)

    return ingredient unless (nested_content = ingredient.name.slice!(NESTED_CONTENT_REGEX))

    if string_contains_a_list?(nested_content)
      ingredient.nested = IngredientParser.new.parse(nested_content)
    else
      ingredient.description = nested_content
    end

    ingredient.name = remove_empty_nest(ingredient.name)

    ingredient
  end

  def string_contains_a_list?(string)
    string.include?(',') || string.scan(AND_OR_REGEX).any? # TODO: could potentially combind these two into 1 scan
  end

  def remove_empty_nest(string)
    string[0...-2]
  end

  def finalize_ingredient(ingredient)
    ingredient = update_description_and_name(ingredient)

    ingredient.name.strip!

    update_and_or_and_name(ingredient)
  end

  def update_description_and_name(ingredient)
    name = ingredient.name.strip

    return ingredient unless (description = parse_description(name))

    ingredient.description = description
    ingredient.name = remove_first_character(name)

    ingredient
  end

  def parse_description(name)
    return unless name.include?(':')

    name.slice!(/^[^\:]*/)
  end

  def remove_first_character(string)
    string[1..-1]
  end

  def update_and_or_and_name(ingredient)
    name = ingredient.name

    return ingredient unless (context = name.slice(AND_OR_REGEX))

    ingredients = name.split(context, 2)
    ingredient.name = ingredients[0]
    and_or_ingredient = Ingredient.new(ingredients[1], context: context.strip)
    ingredient.and_or = finalize_ingredient(and_or_ingredient)

    ingredient
  end
end
