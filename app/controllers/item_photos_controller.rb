class ItemPhotosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]

  def new
    initialize_new_item_photo
    respond_to do |format|
      format.js
    end
  end

  def show
    load_model
    respond_to do |format|
      format.js
    end
  end

  def create
    @model = ItemPhoto.new(item_photo_params)
    @model.user = current_user


    if @model.save
      successfull_create
    else
      unsuccessfull_create
    end
  end

  def destroy
    load_model

    return unless validate_user_permission(@model.user)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  private

  def load_model
    @model = ItemPhoto.find(params[:id])
  end

  def initialize_new_item_photo
    item_id = params[:item_id]
    @model = ItemPhoto.new(item_id: item_id)
  end

  def item_photo_params
    params.require(:item_photo).permit(:item_id, :photo, :photo_cache, :remove_photo, :_destroy)
  end

  def successfull_create
    flash[:success] = "Successfully uploaded photo."
    redirect_to @model.item
  end

  def successfull_destroy
    flash[:success] = "Successfully removed the photo."
    redirect_to @model.item
  end

  def unsuccessfull_destroy
    flash.now[:error] = "Unable to remove the photo"
    render 'items/show'
  end
end
