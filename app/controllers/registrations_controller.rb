class RegistrationsController < Devise::RegistrationsController
  def new_from_oauth
    if session[:oauth].nil?
      render 'errors/error_404', status: 404, layout: 'error'
    end

    build_resource({})
    case session[:oauth].provider
    when 'douban'
      name = session[:oauth].info.name
    end
    respond_with(self.resource, locals: { oauth_data_name: name })
  end

  def create_from_oauth
    # FIXME 1 handle if email already exist
    # FIXME 2 handle if save failed, return false
    # FIXME 3 skip password validation or just generate a random password
    binding.pry
    u = User.new(
      email: params[:user][:email],
      phone: params[:user][:phone],
      name: params[:user][:name],
      password: Devise.friendly_token[0,20])
    u.apply_oauth session[:oauth]
    u.bypass_humanizer = true

    if u.save
      sign_in_and_redirect u, :event => :authentication
    end
  end

  # FIXME use this override build_resource correctly
  private

  def build_resource(*args)
    super
    if session[:oauth]
      @user.apply_oauth(session[:oauth])
      # @user.valid?
    end
  end
end
