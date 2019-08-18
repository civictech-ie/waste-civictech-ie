require 'csv'

Street.destroy_all # TODO: rethink this as the app develops

csv_text = File.read(Rails.root.join('lib', 'data', 'streets.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')

StreetImporter.import_csv!(csv)