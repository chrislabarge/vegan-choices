module Sortable
  extend ActiveSupport::Concern

  def sort_by
    sort_by_params || 'view_count'
  end

  def sort_by_params
    sort_method = params[:sort_by]

    return unless verify_sort_method(sort_method)

    sort_method
  end

  # TODO: this method might have to stay with the restaurants contoller
  # because each controller that uses this concern might have different verifiications
  def verify_sort_method(method)
    Restaurant.sort_options.key(method)
  end
end
