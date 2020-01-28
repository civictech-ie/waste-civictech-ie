class HealthController < ApplicationController
  def check
    @street_count = Street.count
    @bin_bag_retailer_count = BinBagRetailer.count
    @provider_count = Provider.count
    render json: {status: 200, streets: @street_count, retailers: @bin_bag_retailer_count, providers: @provider_count}
  end
end
