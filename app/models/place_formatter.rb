class PlaceFormatter
  def self.format(places)
    return formatted_places(places)
  end

  def self.formatted_places(places)
    {results: places.map { |place| format_place(place) }}.to_json
  end

  def self.format_place(place)
    {title: place.structured_formatting["main_text"],
     description: place.structured_formatting["secondary_text"],
     url: Rails.application.routes.url_helpers.new_restaurant_path(place: place.place_id)}
  end
end
