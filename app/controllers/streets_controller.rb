class StreetsController < ApplicationController
  def search
    @query = params[:q]
    @streets = if @query
      Street.advanced_search(display_name: "#{ @query }:*")
    else
      Street.none
    end
  end

  def index
    @streets = Street.order('postcode asc, name asc')
  end

  def show
    @street = Street.find_by(slug: params[:id])
  end
end
