class StreetsController < ApplicationController
  def search
    @query = params[:q]
    @streets = if @query && (@query.length > 1) # no super short queries
      Street.advanced_search(display_name: "#{ @query }:*").limit(8)
    else
      Street.none
    end
  end

  def show
    @street = Street.includes(:providers).find_by(slug: params[:id])
    @query = @street.name
  end
end