class UsersController < ApplicationController
  before_action :authenticate_user!

  def show

      @model = User.find(params[:id])
  #   @title = @model.name

  #   unless @model == current_user
  #     # this shouldnt be here, I will want users to look and other users profiles.
  #     redirect_to :back, alert: "Access Denied"
  #   end
  end

  def update # have the form perform a remote call to this
    @model = User.find(params[:id])

    if @model.update_attributes(user_params)
      #this will have to change when I include a edit form, because they will be updating their yusername and not creating it
      flash[:success] = "Successfully created a username"
      redirect_to @model
    else
      flash.now[:error] = "Unable to update"
      render :show
    end
  end


  def user_params
    params.require(:user).permit(:name)
  end
end
