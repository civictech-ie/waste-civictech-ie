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
      f.json { render json: @street.as_json(only: [:name, :slug, :postcode, :bag_street, :collection_days, :collection_start, :collection_duration, :presentation_days, :presentation_start, :presentation_duration, :updated_at]) }
    end
  end
end

{"id":1812,"name":"Bloomfield Cottages","slug":"8-bloomfield-cottages","postcode":"8","bag_street":false,"created_at":"2019-09-30T09:15:24.715Z","updated_at":"2019-09-30T09:15:24.715Z","display_name":"Bloomfield Cottages, Dublin 8","collection_days":["tuesday"],"collection_start":21600,"collection_duration":54000,"presentation_days":["monday"],"presentation_start":64800,"presentation_duration":97200}