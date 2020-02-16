require "net/http"
require "json"

class GoogleMaps
  def self.calculate_distance_between(retailer, street) # return duration in seconds
    res = fetch_walking_distance(retailer.google_maps_address, street.google_maps_address)[0]
    if res
      res['elements'][0]['duration']['value']
    else
      nil
    end
  end

  def self.fetch_walking_distance(origins, destinations)
    api_key = Rails.application.credentials.google_api_key
    uri = URI::HTTPS.build(
      :host => "maps.googleapis.com",
      :path => "/maps/api/distancematrix/json",
      :query => {
        :origins => origins,
        :destinations => destinations,
        :mode => 'walking',
        :key => api_key
      }.to_query
    )

    response = Net::HTTP.get_response(uri)
    return JSON.parse(response.body)['rows']
  end
end
