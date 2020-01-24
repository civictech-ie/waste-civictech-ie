class Api::V1::StreetsController < Api::V1::ApplicationController
  def search
    @query = params[:q]
    @streets = if @query && (@query.length > 1) # no super short queries
      Street.advanced_search(display_name: "#{ @query }:*").limit(8)
    else
      Street.none
    end

    render json: @streets
  end

  def index
    @streets = Street.order('name asc')
    render json: @streets
  end

  def show
    @street = Street.find_by(slug: params[:id])
    @query = @street.name
    render json: @street
  end
end