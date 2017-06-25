class ItemsController < ApplicationController
  before_action :load_model, except: [:index, :type_form]

  def index
  end

  def show
  end

  def edit
    load_edit_variables
  end

  def type_form
    @title = 'Select The Item\s Category'

    redirect_to type_form_redirect_url
  end

  def update
    @model.update_attributes(item_params) ? successful_update : unsuccessful_update
  end

  def item_ingredients
    set_item_ingredients_variables

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def load_items
    @items = Item.all
  end

  def set_index_variables
    @title = 'Items'
  end

  def set_item_ingredients_variables
    @item_ingredients = @model.main_item_ingredients.eager_load(:ingredient, :item_ingredients)
    @recipe = @model.recipe
  end

  def load_model
    @model = Item.find(params[:id])
  end

  def load_edit_variables
    @restaurant = @model.restaurant
    @items = @restaurant.items.other
    @item_type_id = find_item_type_id
  end

  def restaurant_params
    params[:restaurant_id]
  end

  def load_restaurant
    return unless (params = restaurant_params).present?
    @restaurant =  Restaurant.find(restaurant_params)
  end

  def item_params
    params.require(:item).permit(:item_type_id)
  end

  def type_form_redirect_url
    item = type_form_item

    item ? edit_item_url(item) : all_items_categorized
  end

  def type_form_item
    if load_restaurant
      Item.find_by(restaurant: @restaurant, item_type: nil)
    else
      Item.find_by(item_type: nil)
    end
  end

  def successful_update
    flash[:success] = 'Updated the item category.'

    redirect_to(update_redirect_url)
  end

  def unsuccessful_update
    flash.now[:error] = 'Unable to update the category.'
    render :edit
  end

  def update_redirect_url
    next_item = find_next_item
    return edit_item_url next_item if next_item
    all_items_categorized
  end

  def find_next_item
    restaurant = @model.restaurant
    results = Item.where(restaurant: restaurant, item_type: nil) || Item.where(item_type: nil)

    results.first
  end

  # THis is really sloppy, I need to rethink how to use other.
  def find_item_type_id
    @model.item_type_id || ItemType.find_by(name: ItemType::OTHER).try(:id)
  end

  def all_items_categorized
    flash[:success] += ' No Items to update.'
    restaurants_url
  end
end
