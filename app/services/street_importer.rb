require 'csv'

# takes tabular data and creates a bunch of Street records

class StreetImporter
  def self.import_sheet!(sheet)
    labels = sheet.values[0]
    sheet_rows = sheet.values[1..-1]

    sheet_rows.each do |sheet_row|
      import_row!(labels.zip(sheet_row).to_h)
    end
  end

  def self.import_row!(row_hash) # TODO refactor
    street_params = street_params_from_citywide_row(row_hash)
    slug = "#{ street_params[:postcode] } #{ street_params[:name] }".downcase.parameterize

    s = Street.find_or_initialize_by(slug: slug)
    s.assign_attributes(street_params)
    s.seeded_at = Time.now
    s.save!

    add_providers_to_street(s, row_hash)
  end

  # only for citywide sheet
  def self.street_params_from_citywide_row(h)
    h = h.transform_keys(&:downcase)
    collection_area_to_params(h['collectionarea']).merge({
      name: h["steetname"],
      sraid_ainm: h["sraidainm"],
      postcode: h['postcode'],
      presentation_method: parse_presentation_method(h['bagstreet'])
    })
  end

  # atm this is hardcoded and shouldn't be!
  def self.collection_area_to_params(area)
    case area&.downcase&.to_sym
    when :monday
      {collection_days: ['monday'], collection_start: 6.hours.to_i, collection_duration: (21 - 6).hours.to_i, presentation_days: ['sunday'], presentation_start: 18.hours.to_i, presentation_duration: (24-18+21).hours.to_i}
    when :tuesday
      {collection_days: ['tuesday'], collection_start: 6.hours.to_i, collection_duration: (21 - 6).hours.to_i, presentation_days: ['monday'], presentation_start: 18.hours.to_i, presentation_duration: (24-18+21).hours.to_i}
    when :wednesday
      {collection_days: ['wednesday'], collection_start: 6.hours.to_i, collection_duration: (21 - 6).hours.to_i, presentation_days: ['tuesday'], presentation_start: 18.hours.to_i, presentation_duration: (24-18+21).hours.to_i}
    when :thursday
      {collection_days: ['thursday'], collection_start: 6.hours.to_i, collection_duration: (21 - 6).hours.to_i, presentation_days: ['wednesday'], presentation_start: 18.hours.to_i, presentation_duration: (24-18+21).hours.to_i}
    when :friday
      {collection_days: ['friday'], collection_start: 6.hours.to_i, collection_duration: (21 - 6).hours.to_i, presentation_days: ['thursday'], presentation_start: 18.hours.to_i, presentation_duration: (24-18+21).hours.to_i}
    when :bank_holiday
      {collection_days: ['friday'], collection_start: 8.hours.to_i, collection_duration: (21 - 6).hours.to_i, presentation_days: ['thursday'], presentation_start: 18.hours.to_i, presentation_duration: (24-18+21).hours.to_i}
    when :centralcommercialdistrict
      {collection_days: %w(monday tuesday wednesday thursday friday saturday sunday), collection_start: 19.hours.to_i, collection_duration: (24-19).hours.to_i, presentation_days: %w(monday tuesday wednesday thursday friday saturday sunday), presentation_start: 17.hours.to_i, presentation_duration: (24 - 17).hours.to_i}
    when :nightimeeconomy
      {collection_days: %w(monday tuesday wednesday thursday friday saturday sunday), collection_start: 19.hours.to_i, collection_duration: (24 + 4 - 19).hours.to_i, presentation_days: %w(monday tuesday wednesday thursday friday saturday sunday), presentation_start: 17.hours.to_i, presentation_duration: (24 + 4 - 17).hours.to_i}
    else
      {}
    end
  end

  def self.add_providers_to_street(street, row_hash)
    row_hash.
      slice(*%w(ProviderGreyhound ProviderCityBin ProviderAbbeyWaste ProviderKeyWaste ProviderEcoway ProviderAllenWaste)).
      reject { |k,v| v.blank? }.keys.each do |provider_str|
        provider = Provider.find_or_create_by!(name: get_name_for_provider_str(provider_str))
        ps = ProviderStreet.find_or_create_by!(street: street, provider: provider)
        ps.assign_attributes provider_street_params(provider, street, row_hash)
        ps.save!
    end
  end

  def self.provider_street_params(provider, street, row_hash)
    if provider.slug == 'keywaste'
      { street: street,
        provider: provider }.merge(keywaste_params_for(row_hash))
    else
      {street: street, provider: provider}
    end
  end
  
  def self.keywaste_params_for(row_hash)
    case row_hash['KeyWasteCollectionDay']&.downcase&.strip&.to_sym
    when :monday, :tuesday, :wednesday, :thursday, :friday
      {
        collection_days: [row_hash['KeyWasteCollectionDay']&.downcase&.strip],
        presentation_days: [row_hash['KeyWasteCollectionDay']&.downcase&.strip],
        presentation_start: 17.5.hours.to_i
      }
    when :alldays
      {
        collection_days: %w(monday tuesday wednesday thursday friday saturday sunday),
        presentation_days: %w(monday tuesday wednesday thursday friday saturday sunday),
        presentation_start: 17.5.hours.to_i
      }
    else
      {}
    end
  end

  def self.parse_boolean(b)
    (b.nil? or b.downcase != 'y') ? false : true
  end

  def self.parse_presentation_method(v)
    case v.downcase
    when 'mixed' then 'mixed'
    when 'bag' then 'bag'
    else 'bin'
    end
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

  def self.parse_time_of_day(time_str) # needs to be in HH:MM format
    return nil unless time_str.present?
    hours, minutes = time_str.scan(/(\d+):(\d+)/).first.map(&:to_i)

    raise "Malformed time value" unless hours and minutes

    ((hours * 60 * 60) + (minutes * 60)) # seconds since mdinight
  end

  def self.calculate_duration(start_time, start_days, end_time, end_days) # if either day is nil, it'll be inferred
    start_ssm = parse_time_of_day(start_time)
    end_ssm = parse_time_of_day(end_time)

    days = if start_days.present? && end_days.present? && (start_days.size == 1)
      distance_between_days(start_days.first, end_days.first)
    else # if end_time is less than or equal to start_time then end_day must be the next day
      (end_ssm <= start_ssm) ? 1 : 0
    end

    ((days * 24 * 60 * 60) + (end_ssm - start_ssm)) # duration in seconds
  end

  private

  def self.get_name_for_provider_str(str)
    case str
    when 'ProviderGreyhound' then 'Greyhound'
    when 'ProviderCityBin' then 'City Bin Co'
    when 'ProviderAbbeyWaste' then 'Abbey Waste'
    when 'ProviderKeyWaste' then 'KeyWaste'
    when 'ProviderEcoway' then 'Ecoway'
    when 'ProviderAllenWaste' then 'Allen Waste'
    else
      raise "Unhandled provider string: #{ str }"
    end
  end

  def self.distance_between_days(day_1_str, day_2_str) # only works forwards (day 2 always comes after day 1)
    day_1_int = Date::DAYNAMES.index(day_1_str.capitalize)
    day_2_int = Date::DAYNAMES.index(day_2_str.capitalize)

    if day_2_int >= day_1_int # they fall within the same week
      return (day_2_int - day_1_int)
    else # day_2 falls next week
      return (day_2_int - (day_1_int - 7))
    end
  end
end
