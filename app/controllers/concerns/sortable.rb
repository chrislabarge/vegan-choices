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
end
