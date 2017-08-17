require 'rails_helper'

feature 'Restaurants', js: true do
  scenario 'View Restaurant Show' do
    restaurant = FactoryGirl.create(:restaurant)
    orginal_view_count = restaurant.view_count
    expected = orginal_view_count + 1

    given_a_vistor_is_viewing_a(:restaurant, :index)
    when_they_select_a_restaurant(restaurant)
    the_restautant_view_count_increases(expected, restaurant)
  end

  private

  def when_they_select_a_restaurant(restaurant)
    click_link(restaurant.name)
  end

  def the_restautant_view_count_increases(expected, restaurant)
    actual = restaurant.reload.view_count
    expect(actual).to eq expected
  end
end
