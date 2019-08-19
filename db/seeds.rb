require 'csv'
require "google/apis/sheets_v4"

Street.destroy_all # TODO: rethink this as the app develops

# csv_text = File.read(Rails.root.join('lib', 'data', 'streets.csv'))
# csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

# StreetImporter.import_csv!(csv)

sheet_service = Google::Apis::SheetsV4::SheetsService.new
sheet_service.key = ENV['GOOGLE_API_KEY']
spreadsheet_id = '1OW7vqPXBgymmiQdIJE9GrUgWzCO3hNmhasCTYzuWkUc'
range = 'DumpingWasteTestArea!A1:Q'

response = sheet_service.get_spreadsheet_values spreadsheet_id, range

StreetImporter.import_google_sheets!(response.values)
