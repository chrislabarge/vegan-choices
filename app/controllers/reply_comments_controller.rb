class ReplyCommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!

  def new
    load_reply_receiver

    @title = 'New Comment Reply'
    @model = ReplyComment.new(reply_to: @receiver, comment: Comment.new)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    @model = ReplyComment.new(reply_comment_params)

    @model.comment.user_id = current_user.id

    if @model.save
      successfull_create
    else
      unsuccessfull_create
    end
  end

  private

  def load_reply_receiver
    @receiver = Comment.find(params[:reply_to_id])
  end

  def reply_comment_params
    params.require(:reply_comment).permit(:reply_to_id, comment_attributes: [:id, :content])
  end

  def successfull_create
    flash[:success] = "Successfully created comment reply."
    redirect_to find_comment_path(@model.comment)
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to create reply"
    render :new
  end
end
