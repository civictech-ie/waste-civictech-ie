class BinBagRetailerImporter
  def self.import_google_sheet!(sheet)
    sheet_rows = sheet.values[1..-1]

    sheet_rows.each do |sheet_row|
      BinBagRetailer.create!({
        name: sheet_row[0],
        address: sheet_row[1],
        postcode: sheet_row[2],
        google_map_url: sheet_row[3],
        google_map_has_opening_hours: sheet_row[4] == "Y",
        providers: parse_providers(sheet_row[5..7])
      })
    end
  end

  def self.parse_providers(cols)
    # normalise a bit to decrease jankiness
    cols.reject(&:blank?).map(&:strip).map(&:downcase)
  end
end
