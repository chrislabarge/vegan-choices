class JackInTheBoxParser
  def initialize()
    @parser = HtmlParser.new()
  end

  def parse(item_listing)
    html = File.read item_listing.pathname

    @parser.parse(html, parse_instructions)
  end

  def parse_instructions
    ->(parsed_document) {
      bold_nodes = parsed_document.search('b')[4..-1]
      item_nodes = bold_nodes.select { |node| item_node?(node) }

      collect_items_and_ingredients(item_nodes)
    }
  end

  def collect_items_and_ingredients(item_nodes)
    items_with_ingredients = []

    item_nodes.each do |item|
      @ingredients = ''
      name = format_name(item.text)

      items_with_ingredients << name

      add_ingredients item.next, item_nodes

      items_with_ingredients << @ingredients
    end

    items_with_ingredients
  end

  def format_name(str)
    [0, -1].each do |index|
      while !str[index].present?
        str.slice!(index)
      end
    end

    str
  end

  def item_node?(node)
    content = node.text

    return unless content.present? && correct_size?(content)
    return if content[/Contains|OR|–/]

    true
  end

  def correct_size?(str)
    str.size > 2 && str.size <= 40
  end

  def add_ingredients(node, items)
    return if node.nil? || items.include?(node)

    content = node.try :text
    @ingredients += content if content

    add_ingredients node.next, items
  end
end

