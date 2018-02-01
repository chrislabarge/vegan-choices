require 'rails_helper'

RSpec.describe RestaurantsController, type: :controller do
  pending 'should have named routes for restaurants' do
      restaurant = Restaurant.create(name: 'test')

      get restaurant_path restaurant.slug

      expect(response).to be_success
      puts e.inspect
      restaurant.destroy
  end
end
