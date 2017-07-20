class ItemGenerator

  def initialize(restaurant)
    @restaurant = restaurant
    @item = nil
  end

  def generate
    data_extractor = ItemDataExtractor.new(@restaurant)
    item_data = data_extractor.extract

    generate_items_from_data(item_data)
  end

  def generate_items_from_data(data)
    data.map.with_index do |element, index|
      generate_method = find_generate_method(index)
      send(generate_method, element)
      @item
    end
  end

  def find_generate_method(index)
    return :set_item_attributes unless item_name?(index)

    :load_new_item
  end

  def item_name?(index)
    index % 2 == 0
  end

  def load_new_item(name)
    @item = Item.new(restaurant: @restaurant, name: name)
  end

  def set_item_attributes(str)
    @item.allergens = str.slice!(/Contains:.*?$/i)
    @item.ingredient_string = str
  end
end
