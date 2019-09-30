class ApplicationController < ActionController::Base
  before_action :redirect_domain, if: -> { Rails.env.production? }
  
  protected

  def redirect_domain
    return true if request.host == ENV['APP_DOMAIN']
    
    redirect_to [request.protocol,ENV['APP_DOMAIN'],request.fullpath].join, status: :moved_permanently
  end
end