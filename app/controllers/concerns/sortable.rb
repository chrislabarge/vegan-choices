module Sortable
  extend ActiveSupport::Concern

  def sort_by
    klass = controller_resource_object
    sort_by_params || klass.sort_options.values[0]
  end

  def sort_by_params
    sort_method = params[:sort_by]

    return unless verify_sort_method(sort_method)

    sort_method
  end

  def sorted_resource
    klass = controller_resource_object

    case @sort_by
    when 'content_berries'
      klass.left_joins(:content_berries).group(:id).order('COUNT(content_berries.id) DESC')
    when 'location'
      find_restaurants_by_location(klass)
    when 'name'
      klass.order("#{@sort_by} ASC")
    when 'berry_count'
      User.where.not(name: nil).sort_by(&:berry_count).reverse
    end
  end

  def verify_sort_method(method)
    klass = controller_resource_object
    klass.sort_options.key(method)
  end

  def controller_resource_object
    self.class.to_s.chomp('Controller').singularize.constantize
  end

  def find_restaurants_by_location(klass)
    if current_user.nil? && Rails.env.test?
      redirect_to restaurants_path(sort_by: 'content_berries')
      return []
    elsif current_user.nil?
      location = create_new_location
    else
      unless (location = get_current_user_location)
        flash[:error] = "Please update your user profile's location."
        redirect_to restaurants_path(sort_by: 'content_berries')
        return []
      end
    end

    klass_name = klass.name.downcase.to_sym

    restaurants = location.nearbys(40).where.not("#{klass_name}_id" => nil).map(&klass_name)
    redirect_to restaurants_path(sort_by: 'content_berries') if restaurants.empty?
    restaurants
  end

  def get_current_user_location
    (current_user.location || current_user.create_location_from_ip(request))
  end

  def create_new_location
    # TODO: I am going to want to make sure that this does not keep quering the IP API and that it truley stores the
    # location session.
    unless ((session[:latitude] && session[:latitude] != 0.0) &&  (session[:longitude] && session[:latitude] != 0.0))
      data = request.location.data

      session[:latitude] = data["latitude"]
      session[:longitude] = data["longitude"]
    end

    Location.new(latitude: session[:latitude], longitude: session[:longitude])
  end
end
