class StreetsController < ApplicationController
  def search
    @query = params[:q]
    @streets = if @query && @query.present?
      Street.advanced_search(display_name: "#{ @query }:*").limit(8)
    else
      Street.none
    end
  end

  def show
    @street = Street.find_by(slug: params[:id])
  end
end
