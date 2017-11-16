class ReportCommentsController < ApplicationController
  before_action :authenticate_user!

  def create
    @model = ReportComment.new(report_comment_params)

    @model.report.user_id = current_user.id

    @model.save ? successfull_create : unsuccessfull_create
  end

  private

  def report_comment_params
    params.require(:report_comment).permit(:comment_id,
                                           :report_reason_id,
                                           :custom_resons,
                                           report_attributes: [:id, :info])
  end

  def successfull_create
    flash[:success] = "Thank you for reporting the comment. We will be looking into this."
    redirect_to root_url
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to create your report"
    render :new
  end
end
