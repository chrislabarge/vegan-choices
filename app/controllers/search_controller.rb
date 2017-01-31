class SearchController < ApplicationController
  def restaurants
    @results = Restaurant.search(params[:q])

    respond_to do |format|
      format.html
      format.json { render json: @results }
    end
  end
end
