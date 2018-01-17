class CommentsController < ApplicationController
  include CommentsHelper
  before_action :authenticate_user!

  def edit
    load_model
    @title = "Edit Comment"

    return unless validate_user_permission(@model.user)

    respond_to do |format|
      format.html
      format.js
    end
  end

  def update
    load_model
    return unless validate_user_permission(@model.user)

    @model.update_attributes(model_params) ? successfull_update : unsuccessful_update
  end

  def destroy
    load_model
    return unless validate_user_permission(@model.user)

    @redirect_path = find_comment_path(@model)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  def report
    load_model

    @title = "Report Comment"
    @reasons = ReportComment.reasons
    @report_comment = ReportComment.new(comment: @model, report: Report.new)

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def successfull_update
    flash[:success] = "Successfully updated your comment."

    redirect_to find_comment_path(@model)
  end

  def unsuccessful_update
    flash.now[:error] = "Unable to update your comment"

    render :edit
  end

  def successfull_destroy
    flash[:success] = "Successfully deleted your comment."

    redirect_to @redirect_path
  end

  def unsuccessful_destroy
    flash[:error] = "Unable to delete your comment."
    redirect_to root_url
  end

  def model_params
    params.require(:comment).permit(:content)
  end

  def load_reply_receiver
    @receiver = Comment.find(params[:reply_to_id])
  end

  def load_model
    @model = Comment.find(params[:id])
  end
end
