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
    @restaurants = Restaurant.paginate(:page => params[:page], :per_page => 5)
  end

  def set_index_variables
    @title = 'Restaurants'
  end

  def set_show_variables
    @title = @model.name.titleize
    @item_type_scopes = find_item_type_scopes
    @items = find_items
  end

  def find_item_type_scopes
    ItemType.names.map(&:to_sym) << :other
  end

  def find_items
    items = @model.items

    return items unless @diet

    diet_scope = @diet.name

    items.send(diet_scope)
  end

  def load_model
    @model = Restaurant.find(params[:id])
  end
end
