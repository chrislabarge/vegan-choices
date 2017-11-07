class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def destroy
    load_model

    return unless validate_user_permission(@model.user)

    @model.destroy ? successfull_destroy : unsuccessfull_destroy
  end

  private

  def successfull_destroy
    flash.now[:success] = "Successfully removed the  notification."

    respond_to do |format|
      format.html { copy_flash;
      redirect_to notifications_user_url(@model.user) }

      format.js
    end
  end

  def unsuccessfull_destroy
    flash.now[:error] = "Unable to remove the notification."

    respond_to do |format|
      format.html { render redirect_to(notifications_user_url(@model.user)), status: :unprocessable_entity }

      format.js { render 'errors', status: :unprocessable_entity }
    end
  end

  def load_model
    return unsuccessful_destroy unless (@model = Notification.find(params[:id]))
  end

  def copy_flash
    flash[:success] = flash.now[:success] if flash.now[:success]
    flash[:error] = flash.now[:error] if flash.now[:error]
  end
end
