class StreetsController < ApplicationController
  def search
  end

  def index
    @streets = Street.order('postcode asc, name asc')
  end

  def show
    @street = Street.find_by(slug: params[:id])
  end
end
