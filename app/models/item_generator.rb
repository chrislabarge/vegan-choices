class ItemGenerator

  def initialize(restaurant)
    @restaurant = restaurant
  end

  def generate
    item_data = gather_data_from_sources
    item = nil

    item_data.each_with_index do |element, index|
      if index % 2 == 0
        item = Item.new(restaurant: @restaurant, name: element)
      else
        item.allergens = element.slice!(/Contains:.*?$/i)
        item.ingredient_string = element
        item.save
      end
    end
  end

  def gather_data_from_sources
    data = []
    item_listings = @restaurant.item_listings

    document_item_listings = item_listings.documents
    online_item_listings = item_listings.online

    data.concat parse_documents(document_item_listings) if document_item_listings.present?
    data.concat scrape_online_listings(online_item_listings) if online_item_listings.present?
  end

  def parse_documents(listings)
    parsed_data = []

    listings.each do |listing|
      parser = ItemListingParser.new(listing)
      parsed_data.concat parser.parse
    end

    parsed_data
  end

  def scrape_online_listings(listings)
    scraped_data = []

    listings.each do |listing|
      scraper = ItemListingScraper.new(listing)

      scraped_data.concat scraper.scrape
    end

    scraped_data
  end
end
