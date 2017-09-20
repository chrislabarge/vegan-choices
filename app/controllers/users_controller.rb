class UsersController < ApplicationController
  before_action :authenticate_user!

  def show
    #   @model = User.find(params[:id])
  #   @title = @model.name

  #   unless @model == current_user
  #     # this shouldnt be here, I will want users to look and other users profiles.
  #     redirect_to :back, alert: "Access Denied"
  #   end
  end
end
