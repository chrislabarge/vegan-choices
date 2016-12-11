class StaticController < ApplicationController
  def index
    @title = ENV['APP_NAME']
  end

  def restaurant_search
    load_restaurant
    redirect_to restaurant_path(@restaurant)
  end

  private

  def load_restaurant
    attribute = :name if value = params[:restaurant_name]
    attribute = :id if value == params[:restaurant_id]

    @restaurant = Restaurant.find_by(attribute => value)
  end
end
