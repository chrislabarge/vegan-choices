class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_diet
  before_action :load_app_name
  before_action :load_search_placeholder
  before_action :load_social_urls

  def load_diet
    name = ENV['DIET']
    @diet = Diet.find_by(name: name)
    @body_class = 'pushable'
  end

  def load_app_name
    @app_name = ENV['APP_NAME']
  end

  def load_search_placeholder
    @search_placeholder = 'Search for restaurants'
  end

  def load_social_urls
    @facebook_url = ENV['FACEBOOK_URL']
    @twitter_url = ENV['TWITTER_URL']
    @instagram_url = ENV['INSTAGRAM_URL']
  end

  def load_html_title(title = @title)
    @html_title = title.titleize
  end

  def load_html_description(description)
    @html_description = description
  end

  # Devise override
  def after_sign_in_path_for(_resource)
    return name_user_path(current_user) if current_user.name.nil?
    current_user
  end

  # def after_update_path_for(resource)
  #   binding.pry
  #   user_path(resource)
  # end

  def validate_user_permission(user)
    if user_authorized?(user)
      true
    else
      render_forbidden_error
      false
    end
  end

  def render_forbidden_error
    render 'http_errors/page', status: :forbidden,
                               locals: { title: 'Forbidden',
                                         status_code: '403',
                                         message: 'You do not have permission to view this page.' }
  end

  def user_authorized?(user)
    current_user && user && (current_user == user)
  end

  def load_view_options
    @header = (params[:header] == "true")
  end

  def load_location
    @location = (@model.location || @model.locations.build)
  end
end
