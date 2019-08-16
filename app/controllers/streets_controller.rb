class StreetsController < ApplicationController
  def search
  end

  def index
    raise 'todo'
  end

  def show
    @street = Street.find_by(slug: params[:id])
  end
end
