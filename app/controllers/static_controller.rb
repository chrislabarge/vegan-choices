class StaticController < ApplicationController
  def index
    @body_class = 'landing-page'
    @title = "Welcome to #{@app_name}"
  end

  def about
    @title = "About #{@app_name}"
  end
end
