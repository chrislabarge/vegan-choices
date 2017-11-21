class ItemCommentsController < ApplicationController
  before_action :authenticate_user!

  def new
    load_item
    @title = @item.name.titleize + ' Comment'

    @model = ItemComment.new(item: @item, comment: Comment.new)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @model = ItemComment.new(item_comment_params)

    @model.comment.user_id = current_user.id

    if @model.save
      @item = @model.item
      successfull_create
    else
      unsuccessfull_create
    end
  end

  private

  def load_item
    @item = Item.find(params[:item_id])
  end

  def item_comment_params
    params.require(:item_comment).permit(:item_id, comment_attributes: [:id, :content])
  end

  def successfull_create
    redirect_to comments_item_url(@item)
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to create your comment"
    render :new
  end
end
