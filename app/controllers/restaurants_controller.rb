class RestaurantsController < ApplicationController
  before_action :load_model, except: :index

  def index
    set_index_variables
    load_restaurants
  end

  def show
    set_show_variables
  end

  private

  def load_restaurants
    @restaurants = Restaurant.all
  end

  def set_index_variables
    @title = 'Restaurants'
  end

  def set_show_variables
    @title = @model.name.titleize
    @items_by_type = @model.items_mapped_by_type
  end

  def load_model
    @model = Restaurant.find(params[:id])
  end
end
