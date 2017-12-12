class RestaurantCommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    @title = 'New Restaurant Comment'

    load_restaurant

    @model = RestaurantComment.new(restaurant: @restaurant, comment: Comment.new)
    @list = list_view?

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @model = RestaurantComment.new(restaurant_comment_params)

    @model.comment.user_id = current_user.id

    if @model.save
      @restaurant = @model.restaurant
      successfull_create
    else
      unsuccessfull_create
    end
  end

  private

  def load_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def list_view?
    params[:list]
  end

  def restaurant_comment_params
    params.require(:restaurant_comment).permit(:restaurant_id, comment_attributes: [:id, :content])
  end

  def successfull_create
    flash[:success] = 'Successfully created the comment'
    redirect_to restaurant_url(@restaurant, anchor: 'comments')
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to create your comment"
    render :new
  end
end
