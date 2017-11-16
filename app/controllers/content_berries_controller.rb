class ContentBerriesController < ApplicationController
  before_action :authenticate_user!

  def create
    @model = ContentBerry.new(content_berries_params)
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

  def content_berries_params
    params.require(:content_berry).permit(:comment_id, :restaurant_id, :item_id)
  end

  def successfull_create
    flash.now[:success] = "Successfully gave a berry to the user."

    respond_to do |format|
      format.html { copy_flash;
      #this has to be dynamically determined
      redirect_to restaurant_url(@model.restaurant), status: :created }

      format.js { render 'create', status: :created }
    end
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to give a berry to the user."

    respond_to do |format|
      format.html { redirect_to restaurant_url(@model.restaurant), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def successfull_destroy
    flash.now[:notice] = "Took the berry away from the user."

    @model = ContentBerry.new(@model.type => @resource)

    respond_to do |format|
      format.html { copy_flash;
      #this has to be dynamically determined
      redirect_to restaurant_url(@model.restaurant) }

      format.js
    end

  end

  def unsuccessful_destroy
    flash.now[:error] = "Unable to take away a berry from the user."

    # these redirects will have to get changed dynamically to the @favorites_type
    respond_to do |format|
      format.html { render redirect_to( restaurant_url(@model.restaurant)), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def load_model
    return unsuccessful_destroy unless (@model = ContentBerry.find(params[:id]))
  end

  def load_resource
    @resource_id = @model.send("#{@model.type}_id")
    @resource_name = @model.type
    @resource_class_name = @model.send(@model.type).class.name.downcase.to_sym
  end

  def copy_flash
    flash[:success] = flash.now[:success] if flash.now[:success]
    flash[:error] = flash.now[:error] if flash.now[:error]
  end
end
