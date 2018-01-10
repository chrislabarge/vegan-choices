class ReportItemsController < ApplicationController
  before_action :authenticate_user!

  def create
    @model = ReportItem.new(report_item_params)

    @model.report.user_id = current_user.id

    @model.save ? successfull_create : unsuccessfull_create
  end

  private

  def report_item_params
    params.require(:report_item).permit(:item_id,
                                        :report_reason_id,
                                        :custom_resons,
                                        report_attributes: [:id, :info])
  end

  def successfull_create
    flash[:success] = "Thank you for reporting the item. We will be looking into this."
    redirect_to @model.item
  end

  def unsuccessfull_create
    flash.now[:error] = "Unable to create your report"
    redirect_t0 @model.item
  end
end
