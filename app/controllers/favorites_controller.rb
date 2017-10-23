class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def create
    @model = Favorite.new(favorite_params)
    @model.user = current_user

    load_resource

    @model.save ? successfull_create : unsuccessfull_create
  end

  def destroy
    load_model
    load_resource

    return unless validate_user_permission(@model.user)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  private

  def favorite_params
    params.require(:favorite).permit(:restaurant_id, :item_id)
  end

  def successfull_create
    flash.now[:success] = "You have added the #{@model.type} to your favorites."

    respond_to do |format|
      format.html { copy_flash;
      redirect_to restaurant_url(@model.restaurant), status: :created }

      format.js { render 'create', status: :created }
    end
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to add the #{@model.type} to your favorite list"

    respond_to do |format|
      format.html { redirect_to restaurant_url(@model.restaurant), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def successfull_destroy
    restaurant = @model.restaurant
    flash.now[:notice] = "Successfully removed the #{@model.type} from your favorites."

    @model = Favorite.new(restaurant: restaurant)

    respond_to do |format|
      format.html { copy_flash;
      redirect_to restaurant_url(@model.restaurant) }

      format.js
    end

  end

  def unsuccessful_destroy
    flash.now[:error] = "Unable to remove the #{@model.type} from your favorites."

    # these redirects will have to get changed dynamically to the @favorites_type
    respond_to do |format|
      format.html { render redirect_to( restaurant_url(@model.restaurant)), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def load_model
    return unsuccessful_destroy unless (@model = Favorite.find(params[:id]))
  end

  def load_resource
    @resource = @model.send(@model.type)
  end

  def copy_flash
    flash[:success] = flash.now[:success] if flash.now[:success]
    flash[:error] = flash.now[:error] if flash.now[:error]
  end
end
