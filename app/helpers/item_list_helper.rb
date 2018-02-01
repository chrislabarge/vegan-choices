module ItemListHelper
  def display_items_by_type_list(items)
    content = ''
    sorted_items_by_scope = sort_by_scope_and_count(items)
    sorted_items_by_scope.each do |scope, items|
      scope = :menu_item if scope == :menu
      content += render 'items/list_by_scope', scope: scope, items: items
    end

    content.html_safe
  end

  def sort_by_scope_and_count(items)
    scopes = Item.type_scopes

    sorted_items_by_scope = Item.sort_by_scope(items).sort_by do |scope, items|
      scopes -= [scope]
      items.count
    end

    sorted_items_by_scope = format_the_sorted_items(sorted_items_by_scope)

    scopes.each do |scope|
      sorted_items_by_scope << { scope => [] }
    end

    sorted_items_by_scope
  end

  def format_the_sorted_items(sorted_items_by_scope)
    sorted_items_by_scope.reverse!

    sorted_items_by_scope.map do |scope, items|
      [scope, items.sort_by(&:name)]
    end
  end
end
