class OauthServicesController < ApplicationController
  def index
  end
  
  def create
    binding.pry
    render :text => request.env['omniauth.auth'].to_yaml
  end

  def douban
    binding.pry
  end
end
