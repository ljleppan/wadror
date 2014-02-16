class BeermappingApi
  def self.places_in(city)
    return nil if city.empty?
    city = city.downcase
    Rails.cache.fetch(city, expires_in: 1.week) { fetch_places_in(city) }
  end

  def self.place(id)
    Rails.cache.fetch(id, expires_in: 1.week) { fetch_place(id) }
  end

  def self.fetch_places_in(city)
    url = 'http://stark-oasis-9187.herokuapp.com/api/'

    response = HTTParty.get "#{url}#{ERB::Util.url_encode(city)}"
    places = response.parsed_response['bmp_locations']['location']

    return [] if places.is_a?(Hash) and places['id'].nil?

    places = [places] if places.is_a?(Hash)
    places.inject([]) do | set, place |
      set << Place.new(place)
    end
  end

  def self.fetch_place(id)
    url = "http://beermapping.com/webservice/locquery/#{key}/"
    response = HTTParty.get "#{url}#{id}"
    place = response.parsed_response['bmp_locations']['location']

    Place.new(place)
  end

  def self.key
    Settings.beermapping_apikey
  end
end