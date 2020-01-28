class HealthController < ApplicationController
  def check
    render json: {status: 200, streets: Street.count, retailers: BinBagRetailer.count, providers: Provider.count}
  end
end
