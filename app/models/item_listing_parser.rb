class ItemListingParser
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
    pattern = nil
    seperation_method = nil

    [:split, :scan].each do |attr|
      if (pattern = @item_listing.parse_options["#{attr}_regex"])
        seperation_method = "use_#{attr}_to_seperate"
        break
      end
    end

    pattern ? (regex = Regexp.new pattern) : (return data)

    seperated_elements = send(seperation_method, data, regex)

    format_seperated_elements(seperated_elements)
  end

  def format_seperated_elements(data)
    formatted_data = data.map { |group| group.gsub("\n\n", ' ') }
    formatted_data = formatted_data.map { |group|  group.delete("\n") }
    formatted_data = formatted_data.map(&:strip)

    custom_fix(formatted_data)
  end

  def use_split_to_seperate(data, regex)
    data.split(regex)
  end

  def use_scan_to_seperate(data, regex)
    items = data.scan(regex).flatten
    array = []

    # TODO: Cannot rememvber what this is, exrtract it into its own morthod eventually
    items.each_with_index do |item, index|
      next_element_index = if index != items.count - 1
                             data.index items[index + 1]
                           else
                             data.size - 1
                           end

      array << item.gsub(/\s+/, ' ')
      array << data[(data.index(item) + item.size)...(next_element_index)].gsub(/\s+/, ' ')
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
      element.slice!(':') if index.even?

      if element.starts_with?('CONTAINS', 'Contains') && (name_edits = element.split('.'))[1].present?
        data[index - 1] += name_edits[0]
        data[index] = name_edits[1]
      end

      element.slice! 'Ingredients: '
    end
  end
end
