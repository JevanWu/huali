class OauthRegistrationsController < Devise::RegistrationsController
  # FIXME should redirect if user already binded this provider
  def new_from_oauth
    build_resource({})
    case session[:oauth].provider
    when 'douban', 'weibo', 'qq_connect'
      name = session[:oauth].info.name
    end
    respond_with(self.resource)
  end

  def bind_with_oauth
    if u = User.find_by_email(params[:user][:email])
      if not u.valid_password?(params[:user][:password])
        flash[:alert] = I18n.t 'devise.failure.invalid'
        respond_with(u, location: new_oauth_user_registration_path)
      end
    else
      u = User.new(params[:user])
      if not u.valid?
        respond_with(u, location: new_oauth_user_registration_path)
      end
    end

    u.apply_oauth session[:oauth]
    u.save
    # FIXME handle save failed
    flash[:notice] = I18n.t 'devise.sessions.signed_in'
    sign_in_and_redirect u, :event => :authentication
  end

  private

  def build_resource(*args)
    super
    if session[:oauth]
      @user.apply_oauth(session[:oauth])
    end
  end

end
