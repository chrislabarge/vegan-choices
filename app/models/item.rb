# Item
class Item < ApplicationRecord
  include PathNames

  belongs_to :restaurant, inverse_of: :items
  belongs_to :item_type, inverse_of: :items

  validates :name, presence: true

  delegate :name, to: :restaurant, prefix: true
  delegate :path_name, to: :restaurant, prefix: true
  delegate :image_path_suffix, to: :restaurant, prefix: true

  after_save :no_image_file_notification

  def ingredient_list
    parse_ingredients(ingredients) if ingredients

    # parse_ingredients(ingredients)

    # ingredient_list = ingredients.scan(/(?:\([^()]*\)|[^,])+/).map(&:strip)

    # ingredient_list.each_with_index do |ingredient, index|
    #   ingredient.delete!("\n")
    #   next unless (nested_ingedients = ingredient.slice!(/\(.*?\)/))
    #   nested_ingedients_list = nested_ingedients.gsub(/[()]/, '').split(',').map(&:strip)
    #   ingredient_list[index] = [ingredient.strip, nested_ingedients_list]
    # end
  end

  def image_path_suffix
    restaurant_image_path_suffix + 'items/'
  end

  def parse_ingredients(ingredients) #this should be attatched to the Ingredient class
    ingredient_names = ingredients.scan(/(?:\([^()]*\)|[^,])+/).map(&:strip)

    # ingredient_names.map do |name|
    #   name.delete!("\n")

    #   nested_ingedients = name.slice!(/\(.*?\)/)
    #   nested_ingedients_list = nested_ingedients.gsub(/[()]/, '').split(',').map(&:strip)

    #   nested = pase_ingredients(nested_ingredients)

    #   Ingredient.new(name, nested: nested_ingedients)
    # end

    create_ingredients_from_names(ingredient_names)
  end

  def create_ingredients_from_names(names)
    names.map do |name|
      name.delete!("\n")
      nested_ingredients = nil
      and_or = nil

      if (nested_ingredient_string = name.slice!(/\(.*?\)/)) # TODO: refactor this out
        nested_ingredients = parse_nested_ingredients(nested_ingredient_string)
      end

      if (context = name.slice(/ and\/or | and | or /i)) # TODO: refactor this out
        names = name.split(context)
        name = names[0]
        and_or_name = names[1]

        context.strip!

        and_or = Ingredient.new(and_or_name, context: context)
      end

      Ingredient.new(name.strip, nested: nested_ingredients, and_or: and_or) #, nested: nested_ingedients)
    end
  end

  def parse_nested_ingredients(ingredient_string)
    ingredient_names = ingredient_string.gsub(/[()]/, '').split(',').map(&:strip)
    create_ingredients_from_names(ingredient_names)
  end
end
