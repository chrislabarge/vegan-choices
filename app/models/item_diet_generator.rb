class ItemDietGenerator
  CERTIFIED_REGEX = /certified\W+(\w*)/i

  def initialize(item)
    @item = item
  end

  def generate
    @diets = Diet.all
    @item_diets = []

    return @item_diets unless can_generate_item_diets?

    generate_certified_item_diets

    @diets -= @item_diets.map(&:diet)

    generate_uncertified_item_diets

    @item_diets.compact
  end

  def can_generate_item_diets?
    @diets.present? && enough_data_to_determine_item_diet?
  end

  def enough_data_to_determine_item_diet?
    @item.ingredient_string || @item.allergens
  end

  def generate_certified_item_diets
    return unless (certified_diets = find_certified_diets)

    certified_diets.each { |diet| add_item_diet_instance(diet, certified: true) }
  end

  def find_certified_diets
    diet_names = parse_certified_diet_names.flatten.compact

    return nil unless diet_names.present?

    turn_certified_diet_names_into_objects(diet_names)
  end

  def parse_certified_diet_names
    [:ingredient_string, :allergens].map do |attr|
      str = @item.send(attr)
      str.scan(CERTIFIED_REGEX)
    end
  end

  def turn_certified_diet_names_into_objects(diet_names)
    diets = diet_names.flatten.map do |diet_name|
      name = diet_name.downcase
      @diets.find { |diet| diet.name == name }
    end

    diets.compact
  end

  def generate_uncertified_item_diets
    applicaple_diets = find_applicable_diets_for_item(@diets)

    applicaple_diets.each do |diet|
      add_item_diet_instance(diet)
    end
  end

  def find_applicable_diets_for_item(diets)
    diets.select { |diet| item_dietary_values_applicable_for_diet?(diet) }
  end

  def item_dietary_values_applicable_for_diet?(diet)
    @item.dietary_attributes.each do |attr|

      string = @item.send(attr)

      return false unless string.nil? || diet.pertains_to?(string)
    end

    true
  end

  def add_item_diet_instance(diet, options = {})
    item_diet = find_or_initialize_item_diet(diet)
    item_diet.id ? item_diet.update_attributes(options) : item_diet.assign_attributes(options)

    @item_diets << item_diet
  end

  def find_or_initialize_item_diet(diet)
    ItemDiet.find_by(item: @item, diet: diet) || ItemDiet.new(item: @item, diet: diet)
  end
end
