class ItemImporter
  def initialize(data)
    @data = parse_data(data)
    @errors = []
    @created = 0
    @updated = 0
  end

  def parse_data(data)
    JSON.parse data
  rescue JSON::ParserError
    raise "\nPlease send valid JSON formatted data\n\n"
  end

  def import
    import_data
    display_results
  end

  def import_data
    @records = generate_item_records
    @imported = update_or_create_items
  end

  def generate_item_records
    @data.map do |record|
      begin ItemRecord.new(record)
      rescue => error
        @errors << error.message
        nil
      end
    end.compact
  end

  def process(record)
    item = record.to_item

    item.id ? (@updated += 1) : (@created += 1)

    item.update_attributes(record.attributes)

    item
  end

  def update_or_create_items
    @records.map do |record|
      process(record)
    end.compact
  end

  def display_results
    display_imported_results if @imported
    display_errors
  end

  def display_imported_results
    puts @imported if (count = @imported.count).positive?
    puts "Imported #{count} items."

    return unless  count.positive?

    puts "Created #{@created} #{'item'.pluralize(@created)}"
    puts "Updated #{@updated} #{'item'.pluralize(@updated)}"
  end

  def display_errors
    return unless !@imported || non_imported_records_count.positive?

    puts "Unable to import #{non_imported_records_count} #{'item'.pluralize(non_imported_records_count)}."
    puts @errors
  end

  def non_imported_records_count
    @data.count - (@imported.try(:count).to_i)
  end
end
