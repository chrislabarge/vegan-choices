class ItemsController < ApplicationController
  before_action :load_model, except: [:index, :new, :create]
  before_action :authenticate_user!, except: [:index, :show, :item_ingredients, :comments]

  def index
  end

  def show
    @favorite_items = current_user.try(:favorite_items) || []
    @comments = @model.comments
  end

  def new
    load_restaurant
    @title = "Add Vegan Option"
    @model = Item.new(restaurant: @restaurant)
  end

  def create
    @model = Item.new(item_params)
    @model.user_id = current_user.id

    create_model ? successful_create : unsuccessful_create
  end

  def edit
    @title = "Update the Vegan Option"
    return unless validate_user_permission(@model.user)
  end

  def update
    return unless validate_user_permission(@model.user)

    @model.update_attributes(item_params) ? successful_update : unsuccessful_update
  end

  def destroy
    return unless validate_user_permission(@model.user)

    @model.destroy ? successful_destroy : unsuccessful_destroy
  end

  def item_ingredients
    set_item_ingredients_variables

    respond_to do |format|
      format.html
      format.js
    end
  end

  def comments
    @title = 'Item Comments'
    @comments = @model.comments
  end

  def report
    @title = "Report Item"
    @reasons = ReportItem.reasons
    @report_item = ReportItem.new(report: Report.new, item: @model)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def item_params
    params.require(:item).permit(:restaurant_id, :name, :item_type_id, :description, :instructions)
  end

  def load_items
    @items = Item.all
  end

  def set_index_variables
    @title = 'Items'
  end

  def set_item_ingredients_variables
    @item_ingredients = @model.main_item_ingredients.eager_load(:ingredient, :item_ingredients)
    @item_ingredients = formate_item_ingredients
    @recipe = @model.recipe
  end

  def formate_item_ingredients
    @item_ingredients.where.not(ingredient: nil)
  end

  def load_model
    @model = Item.find(params[:id])
  end

  def load_restaurant
    unless (@restaurant = Restaurant.find params[:restaurant_id])
      flash[:error] = 'Unable to find the restaurant'
      redirect_to root_path
    end
  end

  def create_model
    @model.save && ItemDiet.create(diet: @diet, item: @model)
  end

  def successful_create
    flash[:success] = 'Successfully created an item. Thank you for contributing!'
    redirect_to restaurant_url(@model.restaurant)
  end

  def unsuccessful_create
    flash.now[:error] = 'Unable to create a new item'
    render :new
  end

  def successful_update
    flash[:success] = 'Successfully updated the item. Thank you for contributing!'
    redirect_to restaurant_url(@model.restaurant)
  end

  def unsuccessful_update
    flash.now[:error] = 'Unable to update the item'
    @title = "Update the Item"
    render :edit
  end

  def successful_destroy
    flash[:success] = 'Successfully deleted the item.'
    redirect_to restaurant_url(@model.restaurant)
  end

  # TEST THIS OUT

  def unsuccessful_destroy
    flash.now[:error] = 'Unable to deleted the item'
    render 'restraurants/show'
  end
end
