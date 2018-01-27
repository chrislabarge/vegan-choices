# frozen_string_literal: true
module UsersHelper
  def user_dashboard_lists
    options = User.dashboard_lists

    content = options.map do |name, value|
                path = request.path + '/?list=' + value + "#user_lists"

                link_to(dropdown_name(name, value), path, class: 'item')
              end

    content.join.html_safe
  end

  def dropdown_name(name, value)
    count =  @model.send(value).count

    if count
      name + " (#{count})"
    else
      name
    end
  end

  def index_list_header_options
    options = {}
    options[:row_title] = User.sort_options.key(@sort_by)
    options[:sortable] = true
    # options[:list_options] = 'restaurants/list_options'
    options
  end

  def favorites_title?(title)
    title.downcase.include?('favorite')
  end
end
