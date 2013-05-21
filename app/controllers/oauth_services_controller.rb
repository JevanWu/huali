class OauthServicesController < Devise::OmniauthCallbacksController
  def passthru
    render 'errors/error_404', status: 404, layout: 'error'
  end

  def douban
    oauthorize 'douban'
  end

  private

  def oauthorize(provider)
    session[:oauth] = env["omniauth.auth"]
    if @user = OauthService.find_user(provider, env['omniauth.auth']['uid'])
      # FIXME correct flash notice
      flash[:notice] = I18n.t "devise.omniauth_callbacks.success", :provider => provider
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to new_oauth_user_registration_url
    end
  end

end
