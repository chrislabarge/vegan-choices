# frozen_string_literal: true
module UsersHelper
  def user_dashboard_lists
    options = User.dashboard_lists

    content = options.map do |name, value|
                path = request.path + '/?list=' + value

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
end
