BinBagRetailerImporter.destroy_duplicates!

seed_starts_at = Time.now

# import the city-wide data
data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_CITYWIDE_ID'],ENV['GOOGLE_SHEETS_CITYWIDE_RANGE'])
StreetImporter.import_sheet!(data)

# import the retailer data
bin_bag_retailer_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_BAGSHOPS_ID'],ENV['GOOGLE_SHEETS_BAGSHOPS_RANGE'])
BinBagRetailerImporter.import_google_sheet!(bin_bag_retailer_data)

Street.where('updated_at < ?', seed_starts_at).each do |street|
  street.bin_bag_retailer_streets.destroy_all
  street.provider_streets.destroy_all
  street.destroy!
end