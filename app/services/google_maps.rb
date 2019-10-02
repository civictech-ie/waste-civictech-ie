require "net/http"
require "json"

class GoogleMaps
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
