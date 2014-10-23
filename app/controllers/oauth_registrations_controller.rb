class OauthRegistrationsController < Devise::RegistrationsController
  before_action :verify_session

  def new_from_oauth
    build_resource
    respond_with resource
  end

  def bind_with_oauth
    begin
      if u = User.find_by_email(params[:user][:email])
        flash[:alert] = I18n.t 'devise.oauth_services.user.email_has_been_token'
        redirect_to new_oauth_user_registration_path 
      end 
      u = build_resource permitted_params.merge(name: session[:oauth].info.name, password: SecureRandom.hex )

      u.bypass_humanizer = true
      u.save!
      u.apply_oauth session[:oauth]

      flash[:notice] = I18n.t 'devise.sessions.signed_in'
      sign_in_and_redirect u, :event => :authentication
    rescue ActiveRecord::RecordInvalid
      build_resource permitted_params

      flash[:alert] = I18n.t 'devise.failure.invalid'
      render 'devise/registrations/new_from_oauth'
    end
  end

  private

  def permitted_params
    params.require(:user).permit(:email,
                                 { phone: [] },
                                )
  end

  def verify_session
    if session[:oauth].nil?
      redirect_to :root, status: 403
    end
  end
end
