class ItemDataExtractor
  def initialize(restaurant)
    @item_listings = restaurant.item_listings
  end

  def extract
    return unless @item_listings.present?

    data = item_listing_scopes.map { |scope| extract_by_scope(scope) }

    data.compact.flatten
  end

  def item_listing_scopes
    [:documents, :online]
  end

  def extract_by_scope(scope)
    scoped_listings = @item_listings.send(scope)

    return unless scoped_listings.present?

    collect_data_from_listings(scoped_listings, scope)
  end

  def collect_data_from_listings(listings, type)
    data = listings.map { |listing| collect_data(listing, type) }
    data.flatten
  end

  def collect_data(listing, type)
    extract_method = (type == :documents ? :parse : :scrape)
    klass = "item_listing_#{extract_method}r".classify
    extractor = klass.constantize.new(listing)

    extractor.send(extract_method)
  end
end
