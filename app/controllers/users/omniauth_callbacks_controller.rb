class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def twitter
    set_user

    authenticate_user_with(:twitter)
  end

  def google_oauth2
    set_user

    authenticate_user_with(:google)
  end

  # def facebook
  #   set_user

  #   authenticate_user_with(:facebook)
  # end

  def instagram
    set_user

    authenticate_user_with(:instagram)
  end

  # GET|POST /resource/auth/twitter
  def passthru
    super
  end

  # GET|POST /users/auth/twitter/callback
  def failure
    super
  end

  # protected

  # The path used when OmniAuth fails
  def after_omniauth_failure_path_for(scope)
    super(scope)
  end

  private

  def set_user
    @user = UserAuthentication.from_omniauth(request.env["omniauth.auth"])
  end

  def authenticate_user_with(provider)
    provider = provider.to_s

    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, :success, :kind => provider.titleize) if is_navigational_format?
    else
      session["devise.#{provider}_data"] = request.env["omniauth.auth"].except("extra")
      redirect_to new_user_registration_url
    end
  end
end
