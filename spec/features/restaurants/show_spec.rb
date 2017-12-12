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

  scenario 'a signed in item creator/user can edit the item' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)

    authenticate(user)

    visit restaurant_path(restaurant)

    edit_icon.trigger('click')

    expect(page).to have_content('Update the Restaurant')
  end

  scenario 'a signed in item creator/user cannot report the item' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)

    authenticate(user)

    visit restaurant_path(restaurant)

    expect(page.has_css?('.report-restaurant')).to eq false
  end

  scenario 'a non item creator can report the item' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)
    another_user = FactoryGirl.create(:user)

    authenticate(another_user)

    visit restaurant_path(restaurant)

    find('.report-restaurant a').trigger('click')

    expect(page).to have_content 'Reason for Report'
  end

  scenario 'a non item creator cannot edit the item' do
    user = FactoryGirl.create(:user)
    restaurant = FactoryGirl.create(:restaurant, user: user)
    another_user = FactoryGirl.create(:user)

    authenticate(another_user)

    visit restaurant_path(restaurant)

    expect(page.has_css?('.edit-item')).to eq false
  end

  private

  def when_they_select_a_restaurant(restaurant)
    click_link(restaurant.name)
  end

  def the_restautant_view_count_increases(expected, restaurant)
    actual = restaurant.reload.view_count
    expect(actual).to eq expected
  end

  def edit_icon
    find('.page-header .edit-item .icon')
  end
end
