class OauthRegistrationsController < Devise::RegistrationsController
  before_action :verify_session

  def new_from_oauth
    build_resource
    respond_with resource
  end

  def bind_with_oauth
    begin
      if u = User.find_by_email(params[:user][:email])
        unless u.valid_password? params[:user][:password]
          raise ActiveRecord::RecordInvalid.new(u), 'invalid password'
        end
      else
        u = build_resource permitted_params
      end

      u.bypass_humanizer = true
      u.save!
      u.apply_oauth session[:oauth]

      flash[:notice] = I18n.t 'devise.sessions.signed_in'
      sign_in_and_redirect u, :event => :authentication
    rescue ActiveRecord::RecordInvalid
      flash[:alert] = I18n.t 'devise.failure.invalid'
      render 'devise/registrations/new_from_oauth'
    end
  end

  private

  def permitted_params
    params.require(:user).permit(:email,
                                 :password,
                                 :password_confirmation,
                                 { phone: [] },
                                 :name)
  end

  def verify_session
    if session[:oauth].nil?
      redirect_to :root, status: 403
    end
  end
end
