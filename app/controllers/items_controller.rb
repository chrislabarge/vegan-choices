class ItemsController < ApplicationController
  before_action :load_model, except: :index
  before_action :authenticate_user!, only: :report

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

  def comments
    @title = 'Item Comments'
    @comments = @model.comments
  end

  def report
    @title = "Report Item"
    @reasons = ReportItem.reasons
    @report_item = ReportItem.new(report: Report.new, item: @model)
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
    @item_ingredients = formate_item_ingredients
    @recipe = @model.recipe
  end

  def formate_item_ingredients
    @item_ingredients.where.not(ingredient: nil)
  end

  def load_model
    @model = Item.find(params[:id])
  end
end
