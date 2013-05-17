class OauthServicesController < ApplicationController
  def passthru
    render :file => "#{Rails.root}/public/404.html", :status => 404, :layout => false
  end

  def douban
    oauthorize 'douban'
  end

  private

  def oauthorize(provider)
    session["devise.oauth_data_#{provider}"] = env["omniauth.auth"]
    if @user = OauthService.find_user(provider, env['omniauth.auth']['uid'])
      # FIXME correct flash notice
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :provider => provider
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to new_user_registration_url
    end
  end

end
