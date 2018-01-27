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
      sort_by_location_for(klass)
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

  def sort_by_location_for(klass)
    location = get_user_location

    return  gather_restaurants_from_location(location, klass) if location.present?

    location_sort_error
    return []
  end

  def gather_restaurants_from_location(location, klass)
    klass_name = klass.name.downcase.to_sym
    restaurants = location.nearbys(40).where.not("#{klass_name}_id" => nil).map(&klass_name)

    return restaurants unless restaurants.empty?

    no_nearby_restaurants_message
    Restaurant.none
  end

  def get_user_location
    return nil if (test_visitor)
    return new_location_instance if current_user.nil?

    location =  (current_user.location || create_location_for(current_user))

    return location if location.present?

    flash[:error] = "Please update your user profile's location."
    nil
  end

  def create_location_for(user)
    data = get_geodata_from_ip

    user.create_location_from_ip(data)
  end

  def new_location_instance
    set_session_coordinates unless session_coordinates_are_set
    return uness session_coordinates_are_set

    Location.new(latitude: session[:latitude], longitude: session[:longitude])
  end

  def set_session_coordinates
    data = get_geodata_from_ip || {}

    session[:latitude] = data["latitude"]
    session[:longitude] = data["longitude"]
  end

  def session_coordinates_are_set
    coordinates_are_present(session[:latitude], session[:longitude])
  end

  def coordinates_are_present(lng, lat)
    coordinate_is_present(lng) && coordinate_is_present(lat)
  end

  def coordinate_is_present(coordinate)
    coordinate.present? && coordinate != 0.0
  end

  def test_visitor
    (current_user.nil? && Rails.env.test?)
  end

  def no_nearby_restaurants_message
    flash.now[:warning] = "Unable to find any nearby restaurants. Add some today!"
  end

  def location_sort_error
    redirect_to restaurants_path(sort_by: 'content_berries')
  end
end
