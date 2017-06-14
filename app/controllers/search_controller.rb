class SearchController < ApplicationController
  before_action :search

  def restaurants
    respond_to do |format|
      format.html { process_results }
      format.json { render json: @results }
    end
  end

  def search
    @query = params[:q]
    @results = Restaurant.search(@query)
  end

  def process_results
    return set_restaurants_variables unless @results.empty?

    flash[:notice] = no_search_results_message
    redirect_to restaurants_url
  end

  def set_restaurants_variables
    @title = 'Restaurant Search Results'
    @subtitle = "(for term: '#{@query}')"
    @results = @results.paginate(page: params[:page], per_page: 5)
  end

  def no_search_results_message
    "Unable to find any restaurants that match the search term '#{@query}'"
  end
end
