Street.destroy_all # TODO: rethink this as the app develops
BinBagRetailer.destroy_all

# import from google sheet
tabular_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_STREETS_ID'],ENV['GOOGLE_SHEETS_STREETS_RANGE'])
StreetImporter.import_google_sheet!(tabular_data)

# or comment-out the above and uncomment the below to import from the csv at `lib/data/streets.csv`
# csv_file = File.read(Rails.root.join('lib', 'data', 'streets.csv'))

bin_bag_retailer_data = GoogleSheets.fetch_range_from_sheet('GOOGLE_SHEETS_BAGSHOPS_ID','GOOGLE_SHEETS_BAGSHOPS_RANGE')
BinBagRetailerImporter.import_google_sheet!(bin_bag_retailer_data)
