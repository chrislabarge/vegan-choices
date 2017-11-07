class UsersController < ApplicationController
  before_action :authenticate_user!, except: :show
  before_action :load_model

  def show
    @favorite_restaurants = @model.favorite_restaurants.paginate(page: params[:page], per_page: 6)
    @title = @model.try(:name)
    @visitor = (@model != current_user)

    load_favorite if @visitor
  end

  def update # have the form perform a remote call to this
    if @model.update_attributes(user_params)
      #this will have to change when I include a edit form, because they will be updating their yusername and not creating it
      flash[:success] = "Successfully created a username"
      redirect_to @model
    else
      flash.now[:error] = "Unable to update"
      render :show
    end
  end

  def notifications
    @title = "Notifications"
    @notifications = @model.notifications.paginate(page: params[:page], per_page: 10)
  end

  def load_model
    @model = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name)
  end

  def load_favorite
    @favorite = find_favorite || Favorite.new(profile_id: @model.id)
  end

  def find_favorite
    return unless user_signed_in?
    current_user.favorites.find_by(profile: @model)
  end
end
