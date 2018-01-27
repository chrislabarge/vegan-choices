module MockGooglePlaces
  def mock_google_places(response = [])
    client = double('client')
    allow(GooglePlaces::Client).to receive(:new) { client }
    allow(client).to receive(:predictions_by_input) { response }
  end
end
