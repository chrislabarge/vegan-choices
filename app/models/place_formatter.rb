class PlaceFormatter
  def self.format(places, url)
    return formatted_places(places, url)
  end

  def self.formatted_places(places,url)
    {results: places.map { |place| format_place(place, url) }}.to_json
  end

  def self.format_place(place, url)
    {title: place.structured_formatting["main_text"],
     description: place.structured_formatting["secondary_text"],
     url: url + '?place=' + place.place_id}
  end
end
