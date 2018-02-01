class PlaceImporter
  def initialize
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
  end

  def load_locations(array)
    @locations = array.map do |location|
                   city = location[0]
                   state = location[1]
                   Location.create(country: 'United States', state: state, city: city)
                 end
  end


  def import_places(locations = nil)
    locations ||= @locations
    locations.each { |location| import_place(location) }
  end

  def import_place(location)
    spots = @client.spots(location.latitude, location.longitude, name: 'vegan', radius: 70000, types: 'restaurant')
    return if spots.empty?

    import_google_place(spots.first.place_id, location)
    import_google_place(spots.second.place_id)
    import_google_place(spots.third.place_id)
  end

  def import_google_place(place_id, location = nil)
    place = @client.spot(place_id)
    location ||= Location.create
    restaurant = Restaurant.create(name: place.name, website: place.website, photo_url: place.photos[0].try(:fetch_url, 800))

    location.update_attributes( restaurant: restaurant,
                                country: place.country,
                                state: place.region,
                                city: place.city,
                                latitude: place.lat,
                                longitude: place.lng,
                                street: place.street,
                                street_number: place.street_number,
                                phone_number: place.international_phone_number,
                                hours: place.opening_hours.try(:to_json))

  end
end
