class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_diet
  before_action :load_app_name

  def load_diet
    name = ENV['DIET']
    @diet = Diet.find_by(name: name)
  end

  def load_app_name
    @app_name = ENV['APP_NAME']
  end
end
