class ItemListParser
  def initialize(item_listing)
    @item_listing = item_listing
  end

  def parse
    text = extract_and_clean_text
    seperate_items_from_ingredients(text)
  end

  def extract_and_clean_text
    options = @item_listing.parse_options

    text = extract_document_text(@item_listing.pathname)
    text = extract_relevant_data(text, options["start_str"], options["end_str"])

    remove_pattern(text, options['remove_regex'])
  end

  def extract_document_text(pathname)
    io = File.open(pathname, 'rb')
    reader = PDF::Reader.new(io)
    parsed_text = ''

    reader.pages.each do |p|
      parsed_text += "\n\n"
      parsed_text += p.text
    end

    parsed_text.force_encoding(Encoding::ASCII_8BIT).encode('UTF-8',
                                                            undef: :replace,
                                                            replace: '')
  end

  def extract_relevant_data(parsed_text, start_str = nil, end_str = nil)
    return parsed_text unless start_str || end_str

    starting = start_str ? parsed_text.index(start_str) + start_str.length + 1 : 0
    ending = end_str ? parsed_text.index(end_str) - 1 : -1

    parsed_text[starting..ending]
  end

  def seperate_items_from_ingredients(data)
    return data unless pattern = @item_listing.parse_options['split_regex'] || @item_listing.parse_options['scan_regex']

    regex = Regexp.new pattern


    if @item_listing.parse_options['split_regex']
      split_elements = data.split(regex)
    end

    if @item_listing.parse_options['scan_regex']
      split_elements = scan_test(data, regex)
    end

    format_data(split_elements)
  end

  def format_data(data)
    formatted_data = data.map { |group| group.gsub("\n\n", ' ') }
    formatted_data = formatted_data.map { |group|  group.delete("\n") }
    formatted_data = formatted_data.map(&:strip)

    custom_fix(formatted_data)
  end

  def scan_test(data, regex)
    items = data.scan(regex).flatten
    array = []

    items.each_with_index do |item, index|
        if index != items.count - 1
          next_element_index = data.index items[index + 1]
        else
          next_element_index = data.size - 1
        end
      array << item.gsub(/\s+/, ' ')
      array << data[(data.index(item) + item.size)...(next_element_index)].gsub(/\s+/, ' ') #OK So this little subsitution thing should be used globally for formatting the seperated strings. removes more then 1 white space and \n\n characters
    end

    array
  end

  def remove_pattern(text, pattern)
    return text unless pattern

    regex = Regexp.new pattern

    text.gsub regex, ''
  end

  def custom_fix(data)
    data = data.drop 1 if data[0].blank?
    data.each_with_index do |element, index|
      element.slice!(':') if index % 2 == 0
      previous_element = data[index - 1]

      if element.starts_with?('CONTAINS', 'Contains') && (name_edits = element.split('.'))[1].present?
        data[index - 1] += name_edits[0]
        data[index] = name_edits[1]
      end

      sliced = element.slice! 'Ingredients: '
    end
  end
end
