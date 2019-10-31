class StreetsController < ApplicationController
  def search
    @query = params[:q]
    @streets = if @query && (@query.length > 1) # no super short queries
      Street.advanced_search(display_name: "#{ @query }:*").limit(8)
    else
      Street.none
    end

    respond_to do |f|
      f.html { render action: 'search' }
      f.json { render json: @streets }
    end
  end

  def index
    @streets = Street.order('name asc')

    respond_to do |f|
      f.json { render json: @streets.as_json(only: [:name, :slug]) }
    end
  end

  def show
    @street = Street.find_by(slug: params[:id])
    @query = @street.name

    respond_to do |f|
      f.html { render action: 'show' }
      f.json { render json: @street.as_json(only: [:name, :slug, :postcode, :disposal_method, :collection_days, :collection_start, :collection_duration, :presentation_days, :presentation_start, :presentation_duration, :updated_at]) }
    end
  end
end