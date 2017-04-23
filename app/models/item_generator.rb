class ItemGenerator

  def initialize(restaurant)
    @restaurant = restaurant
    @item_listings = @restaurant.item_listings
    @item = nil
  end

  def generate
    item_data = gather_data_from_sources

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

  def gather_data_from_sources
    item_listings = @restaurant.item_listings
    scopes = [:documents, :online]
    data = scopes.map { |scope| extract_by_scope(scope) }

    data.compact.flatten
  end

  def extract_by_scope(scope)
    scoped_listings = @item_listings.send(scope)

    return unless scoped_listings.present?

    extract_data_from_listings(scoped_listings, scope)
  end


  def extract_data_from_listings(listings, type)
    extracted_data = listings.map { |listing| extract_data(listing, type) }
    extracted_data.flatten
  end

  def extract_data(listing, type)
    extract_method = (type == :documents ? :parse : :scrape)
    klass = "item_listing_#{extract_method}r".classify
    extractor = klass.constantize.new(listing)

    extractor.send(extract_method)
  end
end
