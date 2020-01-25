require 'csv'

# takes tabular data and creates a bunch of Street records

class StreetImporter
  def self.import_sheet!(format, sheet)
    labels = sheet.values[0]
    sheet_rows = sheet.values[1..-1]

    sheet_rows.each do |sheet_row|
      import_row!(format, labels.zip(sheet_row).to_h)
    end
  end

  def self.import_row!(format, row_hash) # TODO refactor
    case format
    when :citywide
      street_params = street_params_from_citywide_row(row_hash)
      slug = "#{ street_params[:postcode] } #{ street_params[:name] }".downcase.parameterize

      s = Street.find_or_initialize_by(slug: slug)
      s.assign_attributes(street_params)
      s.save!
    when :portobello
      street_params = street_params_from_portobello_row(row_hash)
      slug = "#{ street_params[:postcode] } #{ street_params[:name] }".downcase.parameterize

      s = Street.find_or_initialize_by(slug: slug)
      s.assign_attributes(street_params)
      s.save!
    else
      raise 'Unsupported sheet format'
    end

    add_providers_to_street(format, s, row_hash)
  end

  # only for citywide sheet
  def self.street_params_from_citywide_row(h)
    h = h.transform_keys(&:downcase)
    {
      name: h["steetname"],
      postcode: h['postcode'],
      name_gaeilge: h["sraidainm"],
      presentation_method: parse_presentation_method(h['bagstreet'])
    }
  end

  # only for portobello sheet
  def self.street_params_from_portobello_row(h)
    collection_days = parse_days(h['CollectionDay'])
    presentation_start_days = parse_days(h['PresentationDayStart'])
    presentation_end_days = parse_days(h['PresentationDayEnd'])
    {
      name: h['StreetName'],
      postcode: h['Postcode'],
      presentation_method: parse_boolean(h['BagStreet']) ? 'bag' : 'bin',
      collection_days: collection_days,
      collection_start: parse_time_of_day(h['CollectionTimeStart']),
      collection_duration: calculate_duration(h['CollectionTimeStart'], collection_days, h['CollectionTimeEnd'], nil),
      presentation_days: presentation_start_days,
      presentation_start: parse_time_of_day(h['PresentationTimeStart']),
      presentation_duration: calculate_duration(h['PresentationTimeStart'], presentation_start_days, h['PresentationTimeEnd'], presentation_end_days)
    }
  end
  
  # atm this is hardcoded to keywaste...
  def self.provider_street_params_from_portobello_row(h)
    return nil unless h['KeywasteCollectionTimeStart'].present?
    h = h.transform_keys(&:downcase) # because Keywaste/KeyWaste is inconsistent

    street = Street.find_by!(name: h['streetname'])
    provider = Provider.find_or_create_by!(name: 'KeyWaste')

    collection_days = parse_days(h['keywastecollectionday'])
    presentation_start_days = parse_days(h['keywastepresentationdaystart'])
    presentation_end_days = parse_days(h['keywastepresentationdayend'])

    {
      street: street,
      provider: provider,
      collection_start: parse_time_of_day(h['keywastecollectiontimestart']),
      collection_duration: calculate_duration(h['keywastecollectiontimestart'], collection_days, h['keywastecollectiontimeend'], nil),
      collection_days: collection_days,
      presentation_days: presentation_start_days,
      presentation_start: parse_time_of_day(h['keywastepresentationtimestart']),
      presentation_duration: calculate_duration(h['keywastepresentationtimestart'], presentation_start_days, h['keywastepresentationtimeend'], presentation_end_days)
    }
  end

  def self.add_providers_to_street(format, street, row_hash)
    case format
    when :citywide
      row_hash.
        slice(*%w(ProviderGreyhound ProviderCityBin ProviderAbbeyWaste ProviderKeyWaste ProviderEcoway ProviderAllenWaste)).
        reject { |k,v| v.blank? }.keys.each do |provider_str|
          provider = Provider.find_or_create_by!(name: get_name_for_provider_str(provider_str))
          ProviderStreet.find_or_create_by!(street: street, provider: provider)
      end
    when :portobello
      ps_params = provider_street_params_from_portobello_row(row_hash)
      if ps_params.present?
        ps = ProviderStreet.find_or_initialize_by(street: street, provider: ps_params[:provider])
        ps.assign_attributes(ps_params)
        ps.save!
      end
    else
      raise 'Unsupported sheet format'
    end
  end

  def self.parse_boolean(b)
    (b.nil? or b.downcase != 'y') ? false : true
  end

  def parse_presentation_method(v)
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
