class BinBagRetailerImporter
  def self.import_google_sheet!(sheet)
    columns = sheet.values[0]
    sheet_rows = sheet.values[1..-1]

    sheet_rows.each do |sheet_row|
      retailer = columns.zip(sheet_row).to_h

      bbr = BinBagRetailer.find_or_initialize_by(google_maps_address: retailer['Google Maps Address'])
      bbr.assign_attributes(
        name: retailer['Shop Name'],
        address: retailer['Shop Address'],
        postcode: retailer['Postcode'],
        google_map_url: retailer['Google Map Location'],
        google_maps_address: retailer['Google Maps Address'],
        google_map_has_opening_hours: retailer['Google Map Opening Times'] == "Y",
        providers: parse_providers([retailer['Has Keywaste'], retailer['Has Greyhound'], retailer['Has Abbey Waste']])
      )
      bbr.save!
    end
  end

  def self.parse_providers(cols)
    # normalise a bit to decrease jankiness
    cols.reject(&:blank?).map(&:strip).map(&:downcase)
  end

  def self.destroy_duplicates!
    BinBagRetailer.pluck(:google_maps_address).uniq.each do |addr|
      BinBagRetailer.where(google_maps_address: addr).each_with_index do |bbr, i|
        next if (i == 0)
        bbr.bin_bag_retailer_streets.destroy_all
        bbr.destroy
      end
    end
  end
end
