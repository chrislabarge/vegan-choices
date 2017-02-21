class ItemListParser
  def parse(file)
    io = File.open('ingredientslist.pdf')
    reader = PDF::Reader.new(io)
    parsed_text = ''

    reader.pages.each { |p| parsed_text += p.text }

    parsed_text
  end

  def generate_items_from_parsed_data(data)
    grouped_data = data.split(/^(.*?)\:$/)
    sanitized_data = sanitize_data(grouped_data)
    item = nil


    sanitized_data.each_with_index do |element, index|
      if index % 2 == 0
        item = Item.new(restaurant: Restaurant.last, name: element)
      else
        item.allergens = element.slice!(/Contains:.*?$/i)
        item.ingredient_string = element
        if item.is_vegan?
          item.save
        else
          item.delete
        end
      end
    end
  end

  def sanitize_data(grouped_data)
    sanitized_data = grouped_data.map { |group| group.delete("\n") }
    sanitized_data.reject { |element| element.blank? }
  end
end
