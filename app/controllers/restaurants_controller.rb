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
    @restaurants = (@sort_by ? sorted_restaurants : restaurants)
  end

  def set_index_variables
    @title = 'Restaurants'
    @sort_by = sort_by
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

  def sort_by
    sort_by_params || 'view_count'
  end

  def sort_by_params
    sort_method = params[:sort_by]

    return unless verify_sort_method(sort_method)

    sort_method
  end

  private

  def restaurants
    Restaurant.all.paginate(:page => params[:page], :per_page => 5)
  end

  def sorted_restaurants
    Restaurant.order("#{@sort_by} ASC").paginate(:page => params[:page], :per_page => 5)
  end

  def verify_sort_method(method)
    Restaurant.sort_options.key(method)
  end
end
