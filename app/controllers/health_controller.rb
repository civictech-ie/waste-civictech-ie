class HealthController < ApplicationController
  def check
    @count = Street.count
    render json: {status: ((@count > 500) ? 200 : 500), streets: @count}
  end
end
