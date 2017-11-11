class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_model
  before_action :load_page, only: [:edit, :name]

  def show
    @favorite_restaurants = @model.favorite_restaurants.paginate(page: params[:page], per_page: 6)
    @title = @model.try(:name)
    @visitor = (@model != current_user)

    load_favorite if @visitor
  end

  def edit
    return unless validate_user_permission(@model)
    @page = action_name
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
  end

  def load_model
    @model = User.find(params[:id])
  end

  def load_page
    @page = action_name
  end

  def user_params
    param_obj = params.require(:user).permit(:name, :page)
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
    return 'Successfully created a username.' if @model.name.nil?
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
end
