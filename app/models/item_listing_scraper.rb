class ItemListingScraper
  def initialize(item_listing)
    @item_listing = item_listing
    @scraper = load_restaurant_scraper
  end

  def scrape
    @scraper.scrape(@item_listing.url)
  end

  def load_restaurant_scraper
    restaurant = @item_listing.restaurant
    (restaurant.name.tr('^A-Za-z0-9','') + 'Scraper').constantize.new()
  end
end
