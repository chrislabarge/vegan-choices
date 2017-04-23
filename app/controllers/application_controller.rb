class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :load_diet

  def load_diet
    name = ENV['DIET']
    @diet = Diet.find_by(name: name)
  end
end
