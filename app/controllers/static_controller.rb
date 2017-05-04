class StaticController < ApplicationController
  def index
    @body_class = 'pushable landing-page'
    @title = "Welcome to #{@app_name}"
    @hero_description = 'A service that discovers your food options at restaurants'
  end

  def about
    @title = "About #{@app_name}"
  end
end
