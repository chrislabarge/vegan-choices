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
end
