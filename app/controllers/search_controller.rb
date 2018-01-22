class SearchController < ApplicationController
  before_action :search
  before_action { load_html_title('results') }
  before_action { load_html_description(search_description) }

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

  def google_places
   @results = find_places

    respond_to do |format|
      format.json { render json: PlaceFormatter.format(@results) }
    end
  end

  private

  def find_places
    @query = params[:q]
    @client = GooglePlaces::Client.new(ENV['GOOGLE_API_KEY'])
    location = current_user.location

    @client.predictions_by_input(@query, lat: location.try(:latitude),
                                         lng: location.try(:longitude),
                                         radius: 70000,
                                         types: 'establishment')
  end

  def process_results
    return set_restaurants_variables unless @results.empty?

    flash[:warning] = no_search_results_message
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

  def search_description
    "View the results of your search term to help find applicable vegan food items on #{@app_name}."
  end
end
