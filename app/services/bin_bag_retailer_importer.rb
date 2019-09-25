class BinBagRetailerImporter
  def self.import_google_sheet!(sheet)
    labels = sheet.values[0]
    sheet_rows = sheet.values[1..-1]

    sheet_rows.each do |sheet_row|
      providers = [sheet_row[5], sheet_row[6], sheet_row[7]]
        .select { |provider| provider.to_s.strip != "" }

      BinBagRetailer.create!({
        name: sheet_row[0],
        address: sheet_row[1],
        postcode: sheet_row[2],
        google_map_url: sheet_row[3],
        google_map_has_opening_hours: sheet_row[4] == "Y",
        providers: providers
      })
    end
  end
end
