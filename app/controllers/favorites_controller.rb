class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def new
    # @restaurant = Restaurant.find(params[:restaurant_lid])
    # @model = find_favorite || Favorite.new(restaurant: @restaurant)
  end

  def create
    @model = Favorite.new(favorite_params)
    @model.user = current_user

    @model.save ? successfull_create : unsuccessfull_create
  end

  def destroy
    load_model

    return unless validate_user_permission(@model.user)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  private

  def favorite_params
    params.require(:favorite).permit(:restaurant_id)
  end

  def successfull_create
    flash.now[:success] = "You have added the restaurant to your favorites."
    @error = nil

    respond_to do |format|
      format.html { copy_flash;
                    redirect_to restaurant_url(@model.restaurant), status: :created }

      format.js { render 'create', status: :created }
    end
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to add the restaurant to your favorite list"
    @error = flash.now[:error]

    respond_to do |format|
      format.html { redirect_to restaurant_url(@model.restaurant), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def successfull_destroy
    restaurant = @model.restaurant
    flash.now[:success] = "Successfully removed the restaurant from your favorites."

    @model = Favorite.new(restaurant: restaurant)

    respond_to do |format|
      format.html { copy_flash;
      redirect_to restaurant_url(@model.restaurant) }

      format.js
    end

  end

  def unsuccessful_destroy
    flash.now[:error] = "Unable to remove the restaurant from your favorites."

    respond_to do |format|
      format.html { render redirect_to( restaurant_url(@model.restaurant)), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def load_model
    @model = Favorite.find(params[:id])
  end

  def copy_flash
    flash[:success] = flash.now[:success] if flash.now[:success]
    flash[:error] = flash.now[:error] if flash.now[:error]
  end
end
