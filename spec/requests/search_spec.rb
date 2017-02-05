require 'rails_helper'

describe 'Search Restaurants', type: :request do
  let(:restaurant) { FactoryGirl.create(:restaurant) }
  let(:headers) { { 'ACCEPT' => 'application/json' } }
  let(:name) { restaurant.name }

  context 'when searching for an existing restaurant by name' do
    it 'responds with search results containing the restaurant' do
      get '/search/restaurants', params: { q: name },
                                 headers: headers

      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      expect(response.body).to include(name)
    end
  end

  context 'when searching for an non existing restaurant by name' do
    it 'responds with search results containing the restaurant' do
      restaurant.delete

      get '/search/restaurants', params: { q: name },
                                 headers: headers

      expect(response.status).to eq(200)
      expect(response.content_type).to eq('application/json')
      expect(response.body).not_to include(name)
    end
  end
end
