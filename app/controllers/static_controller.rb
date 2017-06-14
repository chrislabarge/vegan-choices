class StaticController < ApplicationController
  def index
    @body_class = 'pushable landing-page'
    @title = "Welcome to #{@app_name}"
    @hero_description = 'Discover what\'s vegan at restaurants!'
  end

  def about
    @title = "About #{@app_name}"
  end
end
