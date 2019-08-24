Street.destroy_all # TODO: rethink this as the app develops

# import from google sheet
tabular_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_ID'],ENV['GOOGLE_SHEETS_RANGE'])
StreetImporter.import_google_sheet!(tabular_data)

# or comment-out the above and uncomment the below to import from the csv at `lib/data/streets.csv`
csv_file = File.read(Rails.root.join('lib', 'data', 'streets.csv'))