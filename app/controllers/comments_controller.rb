class CommentsController < ApplicationController
  before_action :authenticate_user!

  def edit
    load_model
    @title = "Edit Comment"

    return unless validate_user_permission(@model.user)
  end

  def update
    load_model
    return unless validate_user_permission(@model.user)

    @model.update_attributes(model_params) ? successfull_update : unsuccessful_update
  end

  def destroy
    load_model

    return unless validate_user_permission(@model.user)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  def report
    load_model

    @title = "Report Comment"
    @reasons = ReportComment.reasons
    @report_comment = ReportComment.new(comment: @model, report: Report.new)
  end

  private

  def successfull_update
    flash[:success] = "Successfully updated your comment."

    redirect_to root_url
  end

  def unsuccessful_update
    flash.now[:error] = "Unable to update your comment"

    render :edit
  end

  def successfull_destroy
    flash[:success] = "Successfully deleted your comment."

    # destroy_redirect
    redirect_to root_url
  end

  def unsuccessful_destroy
    flash[:error] = "Unable to delete your comment."
    redirect_to root_url
  end

  def destroy_redirect
    # item = @model.item

    # url = if item.comments.present?
    #         comments_item_url(item)
    #       else
    #         restaurant_url(item.restaurant)
    #       end

    redirect_to url
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
