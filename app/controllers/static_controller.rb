class StaticController < ApplicationController
  def index
    @body_class = 'pushable landing-page'
    @title = "Welcome to #{@app_name}"
    @hero_description = 'Discover what\'s vegan at restaurants!'
    load_html_title('home')
  end

  def about
    @title = "About #{@app_name}"
    load_html_title('about')
    load_html_description(about_description)
  end

  private

  def about_description
    "#{@app_name} only shows you food items that contain no animal products at a restaurant."
  end
end
