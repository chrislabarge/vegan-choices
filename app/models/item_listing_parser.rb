class ItemListingParser

  def initialize(item_listing)
    @item_listing = item_listing
    @parser = load_item_listing_parser
  end

  def parse
    @parser.parse(@item_listing)
  end

  def load_item_listing_parser
    restaurant = @item_listing.restaurant
    klass_str = (restaurant.name.tr('^A-Za-z0-9','') + 'Parser')

    return PdfParser.new unless class_exists? klass_str

    klass_str.constantize.new
  end

  def class_exists?(class_name)
    klass = Module.const_get(class_name)
    return klass.is_a?(Class)
  rescue NameError
    return false
  end

end
