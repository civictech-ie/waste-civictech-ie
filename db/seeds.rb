# import the good Portobello data
portobello_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_PORTOBELLO_ID'],ENV['GOOGLE_SHEETS_PORTOBELLO_RANGE'])
StreetImporter.import_sheet!(:portobello, portobello_data)

# import the shallower city-wide data
citywide_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_CITYWIDE_ID'],ENV['GOOGLE_SHEETS_CITYWIDE_RANGE'])
StreetImporter.import_sheet!(:citywide, citywide_data)

# import the retailer data
bin_bag_retailer_data = GoogleSheets.fetch_range_from_sheet(ENV['GOOGLE_SHEETS_BAGSHOPS_ID'],ENV['GOOGLE_SHEETS_BAGSHOPS_RANGE'])
BinBagRetailerImporter.import_google_sheet!(bin_bag_retailer_data)