class BinBagRetailerImporter
  def self.import_google_sheet!(sheet)
    columns = sheet.values[0]
    sheet_rows = sheet.values[1..-1]

    sheet_rows.each do |sheet_row|
      retailer = columns.zip(sheet_row).to_h

      BinBagRetailer.create!({
        name: retailer['Shop Name'],
        address: retailer['Shop Address'],
        postcode: retailer['Postcode'],
        google_map_url: retailer['Google Map Location'],
        google_map_has_opening_hours: retailer['Google Map Opening Times'] == "Y",
        providers: parse_providers([retailer['Has Keywaste'], retailer['Has Greyhound'], retailer['Has Abbey Waste']])
      })

    end
  end

  def self.parse_providers(cols)
    # normalise a bit to decrease jankiness
    cols.reject(&:blank?).map(&:strip).map(&:downcase)
  end
end
