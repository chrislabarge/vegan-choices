class ApplebeesParser
  def initialize()
    @parser = HtmlParser.new()
  end

  def parse(item_listing)
    html = File.read item_listing.pathname

    @parser.parse(html, parse_instructions)
  end

  def parse_instructions
    ->(parsed_document) do
      @items_with_ingredients = []

      tables = parsed_document.search('div.row')

      tables.each do |table|
        rows = table.search('tbody tr')

        load_allergen_headers(table)

        rows.each { |row| extract_item_content_from(row) }
      end

      @items_with_ingredients
    end
  end

  def load_allergen_headers(table)
    @allergen_headers = table.search('thead th')
    @allergen_headers.shift
  end

  def extract_item_content_from(row)
    row_header = row.search('th').text

    return unless is_item?(row_header)

    @items_with_ingredients << row_header
    @items_with_ingredients << extract_allergens_from(row)
  end

  def is_item?(str)
    !str.include?(':')
  end

  def extract_allergens_from(row)
    allergen_columns = row.search('td')

    allergen_indexes = allergen_columns.each_with_index.select do |e, _|
                         e['class'] == 'present-symbol'
                       end.map(&:last)

    ingredient_str = ''
    ingredient_str = 'Allergens:' if allergen_indexes.present?

    allergen_indexes.each do |index|
      ingredient_str += ' ' + @allergen_headers[index]
    end

    ingredient_str
  end
end
