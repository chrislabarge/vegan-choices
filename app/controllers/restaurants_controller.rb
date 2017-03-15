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

    @item_type_scopes = ItemType.names.map(&:to_sym) << :other
  end

  def items
    items = @model.items

    return unless @diet

    items.send(@diet.name)
  end

  def load_model
    @model = Restaurant.find(params[:id])
  end

  def load_diet
    @diet = Diet.first
  end
end
