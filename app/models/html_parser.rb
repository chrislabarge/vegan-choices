require 'nokogiri'
class HtmlParser
  def parse(html, instructions = nil)
    parsed_document = Nokogiri::HTML(html)

    return parsed_document unless instructions

    instructions.call(parsed_document)
  end

  # def initialize(item_listing)
  #   @item_listing = item_listing
  # end

  # def parse()
  #   @items_with_ingredients = []
  #   filepath = @item_listing.pathname
  #   doc = File.open(filepath) { |f| Nokogiri::HTML(f) }
  #   items = []
  #   pages = doc.search('div')

  #   pages.each do |page|
  #     page.children.each do |node|
  #       next if %w(ft11 ft12 ft13 ft21 ft22 ft23 ft31 ft30 ft32 ft34 ft42 ft41 ft51 ft61 ft62).include? node['class']
  #       @items_with_ingredients << node.text unless node.text == "\n"
  #     end
  #   end

  #   @items_with_ingredients
  # end


  # def parse()
  #   @items_with_ingredients = []
  #   filepath = @item_listing.pathname
  #   doc = File.open(filepath) { |f| Nokogiri::HTML(f) }
  #   items = []
  #   bold = doc.search('b')[4..-1]
  #   bold.each do |b|
  #     items << b if b.text.present? && !b.text.include?('Contains') && !b.text.include?('OR') && !b.text.include?('–') && b.text.size > 2 && b.text.size <= 40
  #   end

  #   items.each do |item|
  #     name = item.text.strip
  #     @ingredients = ''
  #     @items_with_ingredients << name
  #     recursive_loop item.next, items
  #     @items_with_ingredients << @ingredients
  #   end
  #   @items_with_ingredients
  # end

  # def recursive_loop(node, items)
  #   return if node.nil? || items.include?(node)

  #   content = node.try :text
  #   @ingredients += content if content

  #   recursive_loop node.next, items
  # end

    # lists.each do |item_list|
    #   byebug
    #   name = nil
    #   ingredients = ''
    #   list_nodes = item_list.children
    #   list_nodes.each do |content|
    #     if items.include?(content)
    #       name = content.text
    #       if ingredients.present?
    #         @items_with_ingredients << ingredients
    #         @items_with_ingredients << name
    #       elsif @items_with_ingredients.empty?
    #         @items_with_ingredients << name
    #       else
    #         @items_with_ingredients[-1] = @items_with_ingredients[-1] + name
    #       end

    #       ingredients = ''

    #     else
    #       ingredients += content.text
    #       @items_with_ingredients << ingredients if content == list_nodes[-1]
    #     end
    #   end
    # end



    # pages.each_with_index do |page, i|

    #   item_names = page.search('b')[4..-1]
    #   item_names.each do |item|
    #     name = item.text if item.text.present? && !item.text.include?('Contains')

    #   end
    #   item_content = item_content[10..-1] if i == 0


    #   item_content.each_with_index do |content, i|
    #     if content.name == 'span' && !content.text.include?('Contains') && !content.text.include?('OR')
    #       @items_with_ingredients << ingredients if @items_with_ingredients.present?

    #       ingredients = ''
    #       name = content.text

    #       @items_with_ingredients << name
    #     else
    #       ingredients += content.text
    #     end
    #   end

    #   @items_with_ingredients << ingredients
    # end

    # @items_with_ingredients
  # end
end
