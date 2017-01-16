class SearchController < ApplicationController
  def restaurants
    @results = Restaurant.search(params[:q])
    # respond_to do |format|
    #   format.html
    #   format.json
    # end

    test = { results: @results }

    render json: test
  end
end
