Street.destroy_all # TODO: rethink this as the app develops

tabular_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_ID'],ENV['GOOGLE_SHEETS_RANGE'])
StreetImporter.import_google_sheet!(tabular_data)
