class RestaurantsController < ApplicationController
  include Sortable

  before_action :load_model, except: [:index, :new, :create]
  before_action :authenticate_user!, only: [:report, :create, :update, :edit, :new]

  def index
    set_index_variables
    load_restaurants
    load_html_title
    load_html_description(index_description)
  end

  def show
    set_show_variables
    load_html_title
    load_html_description(show_description)
    # update_view_count
  end

  def new
    @title = 'New Restaurant'
    @model = Restaurant.new()
    load_new_location
  end

  def create
    @model = Restaurant.new(restaurant_params)
    @model.user = current_user

    create_model ? successful_create : unsuccessful_create
  end

  def edit
    @title = 'Update the Restaurant'
    return unless validate_user_permission(@model.user)
  end

  def update
    return unless validate_user_permission(@model.user)

    @model.update_attributes(restaurant_params) ? successful_update : unsuccessful_update
  end

  def comments
    @title = "Restaurant Comments"
    @comments = @model.comments.paginate(page: params[:page], per_page: 10)
  end

  def report
    @title = "Report Restaurant"
    @reasons = ReportRestaurant.reasons
    @report_restaurant = ReportRestaurant.new(report: Report.new, restaurant: @model)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private
  def create_model
    @model.save && @model.items.each { |item| ItemDiet.create(diet: @diet, item: item)  }
  end

  def load_restaurants
    @restaurants = (@sort_by ? sorted_restaurants : restaurants)
  end

    def load_new_location
      @location = @model.locations.build

      return unless (user_location = current_user.locations.first)

      @location.country = user_location.country
      @location.state = user_location.state
    end

  def set_index_variables
    @title = 'Restaurants'
    @sort_by = sort_by
  end

  def set_show_variables
    @title = @model.name.titleize
    @item_type_scopes = find_item_type_scopes
    @items = find_items
    @favorite = find_favorite || Favorite.new(restaurant: @model)
    @favorite_items = current_user.try(:favorite_items) || []
    @comments = @model.comments
  end

  def find_item_type_scopes
    ItemType.names.map(&:to_sym)
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

  private
  def restaurant_params
    params.require(:restaurant).permit(:name,
                                       :website,
                                       items_attributes: [:id,
                                                          :name,
                                                          :item_type_id,
                                                          :description,
                                                          :instructions,
                                                          :_destroy],
                                       locations_attributes: [:id,
                                                             :country,
                                                             :state,
                                                             :city])
  end

  def index_description
    "View all of the restaurants #{@app_name} has information on."
  end

  def show_description
    "View all of the animal free items and their ingredients from #{@model.name} at #{@app_name}."
  end

  def restaurants
    Restaurant.all.paginate(:page => params[:page], :per_page => 10)
  end

  def sorted_restaurants
    collection = sorted_resource

    collection.paginate(:page => params[:page], :per_page => 10)
  end

  def update_view_count
    @model.view_count += 1
    @model.save
  end

  def find_favorite
    return unless user_signed_in?
    current_user.favorites.find_by(restaurant: @model)
  end

  def successful_create
    flash[:success] = 'Successfully created the restaurant. Thank you for contributing!'
    redirect_to restaurant_url(@model)
  end

  def unsuccessful_create
    @title = 'Create a new Restaurant'
    flash.now[:error] = 'Unable to create the restaurant.'
    render :new
  end

  def successful_update
    flash[:success] = 'Successfully updated the restaurant. Thank you for contributing!'
    redirect_to restaurant_url(@model)
  end

  def unsuccessful_update
    flash.now[:error] = 'Unable to update the restaurant.'
    render :edit
  end

  def successful_destroy
    flash[:success] = 'Successfully deleted the restaurant.'
    redirect_to restaurant_url(@model)
  end
end
