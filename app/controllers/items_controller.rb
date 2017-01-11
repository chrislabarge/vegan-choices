class ItemsController < ApplicationController
  before_action :load_model, except: :index

  def index
  end

  def show
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
    @item_ingredients = @model.main_item_ingredients
  end

  def load_model
    @model = Item.find(params[:id])
  end
end
