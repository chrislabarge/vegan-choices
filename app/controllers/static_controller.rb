class StaticController < ApplicationController
  def index
    @title = 'Welcome to Vegan Choices'
  end

  def about
    @title = 'About Vegan Choices'
  end
end
