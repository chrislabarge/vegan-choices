class UsersController < ApplicationController
  include Sortable

  before_action :authenticate_user!, except: [:index, :show]
  before_action :load_model, except: :index
  before_action :load_page, only: [:edit, :name]

  def index
    @sort_by = sort_by
    load_users
    @title = 'Users'
  end

  def load_users
    @users = (@sort_by ? sorted_users : users)
  end

  def sorted_users
    collection = sorted_resource
    collection.paginate(:page => params[:page], :per_page => 10)
  end

  def users
    User.where.not(name: nil).paginate(:page => params[:page], :per_page => 10)
  end

  def show
    load_show_variables
  end

  def favorite_restaurants
    @model.favorite_restaurants.paginate(page: params[:page], per_page: 6)
  end

  def edit
    return unless validate_user_permission(@model)

    @page = action_name
    load_location
  end

  def update
    return unless validate_user_permission(@model)

    successful_update_message = determine_update_message
    if @model.update_attributes(user_params)
      successful_update(successful_update_message)
    else
      unsuccessful_update
    end
  end

  def notifications
    @title = "Notifications"
    process_unreceived_notifications

    @notifications = @model.notifications.paginate(page: params[:page], per_page: 10)
  end

  def name
    return unless validate_user_permission(@model)
    redirect_to @model unless @model.name.nil?
    @page = action_name
    load_location
  end

  def load_restaurants
    @favorite_restaurants = favorite_restaurants
    (@favorite_restaurants = sorted_restaurants) if @sort_by
  end

  def sorted_restaurants
    #this willl have to eventually be dynamically selected.
    @favorite_restaurants.order("#{@sort_by} ASC").paginate(:page => params[:page], :per_page => 10)
  end

  def load_model
    @model = User.find(params[:id])
  end

  def load_page
    @page = action_name
  end

  def user_params
    param_obj = params.require(:user).permit(:name,
                                             :page,
                                             :avatar,
                                             :avatar_cache,
                                             :remove_avatar,
                                             locations_attributes: [:id, :country, :state, :city])
    from_page = param_obj.delete("page")
    @current_path ||= from_page
    param_obj
  end

  def load_favorite
    @favorite = find_favorite || Favorite.new(profile_id: @model.id)
  end

  def find_favorite
    return unless user_signed_in?
    current_user.favorites.find_by(profile: @model)
  end

  def determine_update_message
    return 'Successfully created a profile.' if @model.name.nil?
    'Successfully updated your profile.'
  end

  def copy_flash
    flash[:success] = flash.now[:success] if flash.now[:success]
    flash[:error] = flash.now[:error] if flash.now[:error]
  end

  def successful_update(message)
    flash.now[:success] = message
    respond_to do |format|
      format.html do
        flash[:success] = message
        redirect_to @model
      end

      format.js { render 'update', status: :updated }
    end
  end

  def unsuccessful_update
    load_location
    flash.now[:error] = "Unable to update your profile."

    respond_to do |format|
      format.html { copy_flash;
      render find_render_action, status: :unprocessable_entity }

      format.js { render 'update', status: :unprocessable_entity }
    end
  end

  def process_unreceived_notifications
    notifications = @model.notifications.unreceived

    mark_received(notifications) if notifications.present?
  end

  def mark_received(notifications)
    notifications.each { |notification| notification.update( received: true) }
  end

  def find_render_action
    (@page = @current_path.to_sym) if @current_path == 'name' || @current_path == 'edit'
  end

  def load_show_variables
    @sort_by = sort_by
    @visitor = (@model != current_user)
    load_restaurants
    load_list_items
    load_list_row
    load_list_title
    @title = @model.try(:name)
    load_favorite if @visitor
  end

  def load_list_title
    @list_title = User.dashboard_lists.key(list)
  end

  def load_list_items
    @list_items = find_list_items.paginate(page: params[:page], per_page: 6)
  end

  def load_list_row
    @list_row = find_list_row
  end

  def find_list_row
    return 'restaurants/list_row' if list.include?('restaurants')
    return 'items/list_row' if list.include?('items')
    return 'comments/list_row' if list.include?('comments')
    return 'users/list_row' if list.include?('users')
  end

  def find_list_items
    @model.send(list)
  end

  def list
    list_params || (@visitor ? 'comments' : 'favorite_restaurants')
  end

  def list_params
    list_type = params[:list]

    return unless verify_list_type(list_type)

    list_type
  end

  def verify_list_type(type)
    User.dashboard_lists.key(type)
  end
end
