# In spec_helper:
# RSpec.configure do |config|
#   ...
#   config.include(MockGeocoder)
# end
#
# In your tests:
# it 'mock geocoding' do
#   # You may pass additional params to override defaults
#   # (i.e. :coordinates => [10, 20])
#   mock_geocoding!
#   address = Factory(:address)
#   address.lat.should eq(1)
#   address.lng.should eq(2)
# end

require 'geocoder/results/base'

module MockGeocoder
  def self.included(base)
    base.before :each do
      allow(::Geocoder).to receive(:search).and_raise(
        RuntimeError.new 'Use "mock_geocoding!" method in your tests.')
    end
  end

  def mock_data(location = nil)
    country = location.try(:country) || "United States"
    state = location.try(:state) || "New York"
    city = location.try(:city) || "Albany"
    latitude = location.try(:latitude) || 42.6866
    longitude = location.try(:longitude) || -73.729

    { "ip"=>"67.252.24.163",
      "country_code"=>"US",
      "country_name"=> country,
      "region_code"=>"NY",
      "region_name"=> state,
      "city"=> city,
      "zip_code"=>"12204",
      "time_zone"=>"America/New_York",
      "latitude"=> latitude,
      "longitude"=> longitude,
      "metro_code"=>532 }
  end

  def mock_geocoding!(data = mock_data)
    # options.reverse_merge!(
    #   address: 'Address',
    #   coordinates: [1, 2],
    #   state: 'State',
    #   state_code: 'State Code',
    #   country: 'Country',
    #   country_code: 'Country code'
    # )


    MockResult.new(data).tap do |result|
      allow(Geocoder).to receive(:search).and_return([result])
    end
    # MockResult.new.tap do |result|
    #   options.each do |prop, val|
    #     allow(result).to receive(prop).and_return(val)
    #   end
    #   allow(Geocoder).to receive(:search).and_return([result])
    # end
  end


  class MockResult < ::Geocoder::Result::Base
    def initialize(data = [])
      super(data)
    end
  end
end
