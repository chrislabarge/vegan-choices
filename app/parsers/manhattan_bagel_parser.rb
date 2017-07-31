class ManhattanBagelParser
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
      tables = find_tables(parsed_document)

      extract_all_item_content(tables)

      @items_with_ingredients
    end
  end

  def extract_all_item_content(tables)
    tables.each do |table|
      rows = table.search('tr')

      load_allergen_headers(rows.shift)

      rows.each { |row| extract_item_content_from(row) }
    end
  end

  def find_tables(parsed_document)
    (5..8).map do |i|
      parsed_document.at_css("div#page_#{i}")
    end
  end

  def load_allergen_headers(row)
    allergen_headers = row.search('p').map(&:text)
    @allergen_headers = trim_columns(allergen_headers)
  end

  def extract_item_content_from(row)
    load_subtitle(row)

    row_header = row.search('p').first.text.to_s

    return unless row_header.present?

    @items_with_ingredients << row_header + @subtitle
    @items_with_ingredients << extract_allergens_from(row)
  end

  def load_subtitle(row)
    if row.search('td').first['colspan'] == "2"
      @subtitle = if row.text.include? 'Bagel'
                    ' Bagel'
                  elsif row.text.include? 'Cheese'
                    ' ' + row.search('p').first.text
                  else
                    ''
                  end
      return
    end
  end

  def extract_allergens_from(row)
    load_allergen_columns(row)

    allergen_indexes = find_allergen_indexes

    create_ingredient_string(allergen_indexes)
  end

  def load_allergen_columns(row)
    columns = row.search('p')
    @allergen_columns = trim_columns(columns)
  end

  def find_allergen_indexes
    @allergen_columns.each_with_index.select do |e, _|
      e.text == 'X' || e.text == 'X1'
    end.map(&:last)
  end

  def create_ingredient_string(allergen_indexes)
    ingredient_str = ''
    ingredient_str = 'Allergens:' if allergen_indexes.present?

    allergen_indexes.each do |index|
      ingredient_str += ' ' + @allergen_headers[index]
    end

    additional_info = @allergen_columns[-1].text
    ingredient_str += ' ' + additional_info if additional_info.present?

    ingredient_str
  end
end

def trim_columns(columns)
  if columns.count < 13
    columns[1..-1]
  else
    columns[2..-1]
  end
end
