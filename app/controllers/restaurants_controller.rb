class RestaurantsController < ApplicationController
  include Sortable

  before_action :load_model, except: [:index, :new, :create]
  before_action :authenticate_user!, only: [:report, :create, :update, :edit, :new]

  def index
    set_index_variables
    load_html_title
    load_html_description(index_description)
    load_restaurants
  end

  def show
    set_show_variables
    load_html_title
    load_html_description(show_description)
  end

  def new
    @title = 'New Restaurant'
    @submit_text = "Add Restaurant"
    load_new_restaurant
  end

  def create
    @model = Restaurant.new(restaurant_params)
    @model.user = current_user

    build_new_items(@model.items)

    @model.save ? successful_create : unsuccessful_create
  end

  def edit
    @title = 'Update the Restaurant'
    @submit_text = nil

    load_existing_restaurant

    return unless validate_user_permission(@model.user)
  end

  def update
    return unless validate_user_permission(@model.user)

    @model.assign_attributes(restaurant_params)

    new_items = @model.items.select(&:new_record?)

    build_new_items(new_items)

    @model.save ? successful_update : unsuccessful_update
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

  def load_new_restaurant
    @model = google_place || Restaurant.new()

    @model.location || load_new_location
  end

  def load_existing_restaurant
    return unless (restaurant = google_place)

    @model.assign_attributes restaurant.attributes.compact

    @location = @model.location

    @location.assign_attributes restaurant.location.attributes.compact
  end

  def google_place
    return unless @place_id = params[:place]

    return unless place = find_place

    build_google_place_restaurant(place)
  end

  def find_place
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])

    begin
      @client.spot(@place_id)
    rescue => error
      ExceptionNotifier.notify_exception(error)
      return nil
    end
  end

  def build_google_place_restaurant(place)
    photo = place.photos[0].try(:fetch_url,800)
    restaurant = Restaurant.new(name: place.name,
                                website: place.website,
                                photo_url: photo)

    restaurant.locations.build(country: place.country,
                               state: place.region,
                               city: place.city,
                               latitude: place.lat,
                               longitude: place.lng,
                               street: place.street,
                               street_number: place.street_number,
                               phone_number: place.international_phone_number,
                               hours: place.opening_hours.try(:to_json))

    restaurant
  end

  def build_new_items(items)
    items.each do |item|
      item.user= current_user
      item.item_diets.build(diet: @diet)
    end
  end

  def update_model
    @model.items.select(&:new_record?).each { |i| i.update(user: current_user) }
    @model.save && @model.items.select{ |i| i.item_diets.empty? }.each { |item| ItemDiet.create(diet: @diet, item: item)  }
  end

  def load_restaurants
    # if current_user && (location = current_user.location)
    #  @restaurants =  location.nearbys(40).where.not(restaurant: nil).map(&:restaurant)
    #   return
    # end
    @restaurants = (@sort_by ? sorted_restaurants : restaurants)
  end

  def load_new_location
    @model.locations.build

    return unless (location = current_user.location)

    @model.location.country = location.country
    @model.location.state = location.state
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
                                       :photo_url,
                                       :menu_url,
                                       :vegan_menu,
                                       items_attributes: [:id,
                                                          :name,
                                                          :item_type_id,
                                                          :description,
                                                          :instructions,
                                                          :_destroy],
                                       locations_attributes: [:id,
                                                             :country,
                                                             :state,
                                                             :city,
                                                             :street,
                                                             :street_number,
                                                             :phone_number,
                                                             :hours])
  end

  def index_description
    "Sort through and view the listing of restaurants that provide vegan options on #{@app_name}."
  end

  def show_description
    "Discover all of the vegan options at #{@model.name} with #{@app_name}."
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
