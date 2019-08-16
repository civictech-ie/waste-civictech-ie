require 'csv'

Street.destroy_all # TODO: rethink this as the app develops

csv_text = File.read(Rails.root.join('lib', 'data', 'streets.csv'))
csv = CSV.parse(csv_text, headers: true, encoding: 'ISO-8859-1')
csv.each do |row|
  name, postcode, bag_street_raw = row.to_h.values
  bag_street = (bag_street_raw.nil? or bag_street_raw.downcase != 'y') ? false : true
  Street.create!(name: name, postcode: postcode, bag_street: bag_street)
end