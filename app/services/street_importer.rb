class StreetImporter
  def self.import_csv!(csv)
    csv.each do |row|
      import_row! row.to_h
    end
  end

  def self.import_google_sheets!(sheet_values)
    keys = sheet_values[0]
    sheet_values.shift

    sheet_values.each do |row|
      rowHash = {}

      keys.each_with_index do |key, index|
        rowHash[key] = row[index]
      end

      import_row! rowHash
    end
  end

  def self.import_row!(row_hash)
    Street.create!(params_from_hash(row_hash))
  end

  def self.params_from_hash(h)
    {
      name: h['StreetName'],
      postcode: h['Postcode'],
      bag_street: parse_boolean(h['BagStreet']),
      collection_days: parse_days(h['CollectionDay']),
      collection_start: parse_time_of_day(h['CollectionTimeStart']),
      collection_duration: parse_duration(),
      presentation_days: parse_days(h['PresentationDayStart']),
      presentation_start: parse_time_of_day(h['PresentationTimeStart']),
      presentation_duration: parse_duration()
    }
  end

  def self.parse_boolean(b)
    (b.nil? or b.downcase != 'y') ? false : true
  end

  def self.parse_days(days_str) # TODO: this is very hacky
    if days_str.first == '[' # an array
      days_str.scan(/\[(.+)\]/).
        first.first.
        split(',').
        map(&:strip).
        map(&:downcase)
    else
      [days_str.downcase]
    end
  end

  def self.parse_time_of_day(time_str)
    (4 * 3600)
  end

  def self.parse_duration
    (4 * 3600)
  end
end
