class GooglePlacesImporter
  def initialize
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  end

  def process_restaurants(restaurants)
    restaurants.each do |restaurant|
      next unless place = find_place(restaurant)
      import_google_place(place, restaurant)
    end
  end

  def find_place(restaurant)
    location = restaurant.location
    name = restaurant.name
    results = @client.predictions_by_input(name, lat: location.try(:latitude),
                                                 lng: location.try(:longitude),
                                                 radius: 70000,
                                                 types: 'establishment')
    return unless result = results.first

    place = @client.spot(result.place_id)
  end

  def import_google_place(place, restaurant)
    location = restaurant.location || restaurant.locations.create

    location.update_attributes(country: place.country,
                                state: place.region,
                                city: place.city,
                                latitude: place.lat,
                                longitude: place.lng,
                                street: place.street,
                                street_number: place.street_number,
                                phone_number: place.international_phone_number,
                                hours: place.opening_hours.try(:to_json))

    restaurant.update(website: place.website, photo_url: place.photos[0].try(:fetch_url, 800))
  end
end
