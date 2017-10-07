class ItemCommentsController < ApplicationController
  before_action :authenticate_user!


  def new
    # have to think about this form...incase there is an error. I want the same model to be displayed
    @title = 'New Item Comment'
    load_item
    # @model = ItemComment.new(item: @item)
    @comment = Comment.new()
  end

  def create
    load_item

    @comment = Comment.new(comment_params)
    @comment.user = current_user


    if @comment.save && ItemComment.create(item: @item, comment: @comment)
      successfull_create
    else
      unsuccessfull_create
    end
  end

  def edit
    load_model

    @title = "Edit Comment"
    @comment = @model.comment
    user = @comment.user

    return unless validate_user_permission(user)
  end

  def update
    #this update may need to utlize the comment controller sense I really am only updating the comment and nothiong else
    load_model

    @comment = @model.comment
    user = @comment.user

    return unless validate_user_permission(user)

    @comment.update_attributes(comment_params) ? successfull_update : unsuccessful_update
  end

  def destroy
    load_model
    user = @model.user

    return unless validate_user_permission(user)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  private

  def unsuccessfull_create
    flash.now[:error] = "Unable to create your comment"
    render :new
  end

  def successfull_create
    redirect_to comments_item_url(@item)
  end

  def successfull_update
    flash[:success] = "Successfully updated your comment."

    redirect_to comments_item_url(@model.item)
  end

  def unsuccessful_update
    flash.now[:error] = "Unable to update your comment"

    render :edit
  end

  def successfull_destroy
    flash[:success] = "Successfully deleted your comment."

    destroy_redirect
  end

  def unsuccessful_destroy
    flash[:error] = "Unable to delete your comment."
    redirect_to comments_item_url(@model.item)
  end

  def destroy_redirect
    item = @model.item

    url = if item.comments.present?
            comments_item_url(item)
          else
            restaurant_url(item.restaurant)
          end

    redirect_to url
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def load_item
    @item = Item.find(params[:item_id])
  end

  def load_model
    @model = ItemComment.find(params[:id])
  end
end
