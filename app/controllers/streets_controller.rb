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

  def show
    @street = Street.find_by(slug: params[:id])
  end
end
