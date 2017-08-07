class ItemRecord
  def initialize(data)
    @data = data
    @attributes = {}
    @attributes[:restaurant] = find_restaurant
    @attributes[:item_type] = find_item_type
  end

  def attributes
    @attributes.merge(@data)
  end

  def name
    @data["name"]
  end

  def to_item
    Item.find_or_initialize_by(name: name, restaurant: @attributes[:restaurant])
  end

  def find_restaurant
    restaurant_name = @data.delete "restaurant_name"

    unless restaurant = Restaurant.find_by(name: restaurant_name)
      raise "Could not find the Restaurant named '#{restaurant_name}' for #{name}"
    end

    restaurant
  end


  def find_item_type
    type_name = @data.delete "type_name"
    item_type = ItemType.find_by(name: type_name)

    if type_name && !item_type
      raise "Could not find the ItemType named '#{type_name}' for #{name}"
    end

    item_type
  end
end
