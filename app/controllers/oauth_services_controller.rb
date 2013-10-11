class OauthServicesController < Devise::OmniauthCallbacksController
  def passthru(*args)
    render_error 404
  end

  def douban
    oauthorize 'douban'
  end

  def weibo
    oauthorize 'weibo'
  end

  def qq_connect
    oauthorize 'qq_connect'
  end

  private

  def oauthorize(provider)
    session[:oauth] = env['omniauth.auth']
    if @user = OauthService.find_user(provider, env['omniauth.auth']['uid'])
      # FIXME, 'douban' in this notice should be chinese one via i18n
      flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: (I18n.t "devise.oauth_services.providers.#{provider}")
      sign_in_and_redirect @user, :event => :authentication
    else
      redirect_to new_oauth_user_registration_path
    end
  end

end
