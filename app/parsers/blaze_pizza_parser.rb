class BlazePizzaParser
  def initialize()
    @parser = HtmlParser.new()
  end

  def parse(item_listing)
    html = File.read item_listing.pathname

    @parser.parse(html, parse_instructions)
  end

  def parse_instructions
    ->(parsed_document) {
      @items_with_ingredients = []

      pages = parsed_document.search('div')

      pages.each do |page|
        extract_item_content_from(page)
      end

      @items_with_ingredients
    }
  end

  def extract_item_content_from(page)
    nodes = page.children

    nodes.each do |node|
      next if irrelevent_class_names.include? node['class']

      @items_with_ingredients << node.text unless node.text == "\n"
    end
  end

  def irrelevent_class_names
    %w(
        ft11
        ft12
        ft13
        ft21
        ft22
        ft23
        ft31
        ft30
        ft32
        ft34
        ft42
        ft41
        ft51
        ft61
        ft62
      )
  end
end
