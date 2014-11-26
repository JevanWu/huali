module MobileAPI
  class Users < Grape::API

    resource :users do

      desc "Return authentication token for identifying current user." 
      params do
        optional :email, type: String, desc: "User email."
        optional :password, type: String, desc: "User password."
        optional :uid, type: String, desc: "UID"
        optional :oauth_provider, type: String, desc: "the name of the oauth provider"
      end
      post :sign_in do
        if params[:email].present? && params[:password].present?
          user = User.find_by(email: params[:email])
          error!('The user does not exist!', 404) if !user.present?
          if user.valid_password?(params[:password])
            token = user.reset_authentication_token
            status 200
            { 
              authentication_token: token,
              user_email: user.email,
              user_phone: user.phone,
              user_name: user.name,
              set_password: user.set_password
            }
          else
            error!("The account and password don't match!", 500)
          end
        elsif params[:uid] && params[:oauth_provider]
          if user = OauthService.find_user(params[:oauth_provider], params[:uid])
            token = user.reset_authentication_token
            status 200
            { 
              authentication_token: token,
              user_email: user.email,
              user_phone: user.phone,
              user_name: user.name,
              set_password: user.set_password
            }
          else
            if params[:phone].present? && params[:email].present? && params[:name].present?
              user = User.find_by(email: params[:email]) ||  User.create(name: params[:name], phone: params[:phone], email: params[:email], password: SecureRandom.base64(10), bypass_humanizer: true, set_password: false)
              OauthService.create(provider: params[:oauth_provider], uid: params[:uid], oauth_token: params[:access_token], user: user)
              token = user.reset_authentication_token
              status 200
              { 
                authentication_token: token,
                user_email: user.email,
                user_phone: user.phone,
                user_name: user.name, 
                set_password: user.set_password
              }
            else
              status 200
              { new_user: "yes" }
            end
          end
        end
      end

      desc "User sign up and return authentication token for identifying current user." 
      params do
        requires :email, type: String, desc: "User email."
        requires :password, type: String, desc: "User password."
        requires :name, type: String, desc: "User's name."
        requires :phone, type: String, desc: "User's phone number."
      end
      post do
        user = User.create(email: params[:email], password: params[:password], name: params[:name], phone: params[:phone], bypass_humanizer: true) 
        error!(user.errors.messages, 500) if user.errors.messages.present?
        { authentication_token: user.authentication_token }
      end

      desc "Change password for current user." 
      params do
        requires :password, type: String, desc: "Current password."
        requires :new_password, type: String, desc: "New password"
        requires :email, type: String, desc: "email of the user"
        requires :token, type: String, desc: "Authentication token of the user"
      end
      put :change_password do
        authenticate_user!
        user = current_user
        error!("Invalid password", 400) unless user.valid_password?(params[:password])
        user.password = params[:new_password]
        if user.save
          status 200
        else
          error!(current_user.errors.messages, 500)
        end
      end

      desc "Edit user information." 
      params do
        requires :name, type: String, desc: "name of the user"
        requires :phone, type: String, desc: "phone of the user"
        requires :email, type: String, desc: "email of the user"
        requires :token, type: String, desc: "Authentication token of the user"
      end
      put do
        authenticate_user!
        error!("No user signed in", 500) unless current_user
        current_user.update_column(:name, params[:name])
        current_user.update_column(:phone, params[:phone])
        error!(current_user.errors.messages, 500) if current_user.errors.messages.present?
        status 200
      end

      desc "Query the amount of huali point" 
      params do
        requires :email, type: String, desc: "email of the user"
        requires :token, type: String, desc: "Authentication token of the user"
      end
      get :huali_points do
        authenticate_user!
        error!("No user signed in", 500) unless current_user
        { huali_points: current_user.huali_point }
      end

      desc "Check the user already exists or not" 
      params do
        requires :email, type: String, desc: "email of the user"
      end
      get :exist do
        user = User.find_by email: params[:email]
        user.present?
      end

      desc "reseting password sms" 
      params do
        requires :email, type: String, desc: "email of the user"
        requires :phone, type: String, desc: "phone number which the message will be sent to"
      end
      post :password_reset_sms do
        user = User.find_by email: params[:email]
        error!("The user does not exist", 404) if !user.present?
        error!("The phone number mismatchs", 404) if user.phone != params[:phone]
        token = user.generate_reset_password_token
        content = %(您的验证码为#{token} 「花里」)
        Sms.normal_sms(params[:phone], content)
        status 200
      end

      desc "reset password for user" 
      params do
        requires :email, type: String, desc: "email of the user"
        requires :password, type: String, desc: "the new password submited by the user"
        requires :reset_token, type: String, desc: "the reset token sent to user"
      end
      post :reset_password do
        user = User.find_by email: params[:email]
        error!("The user does not exist", 404) if !user.present?
        error!("The reset token mismatchs", 500) if user.reset_password_token != params[:reset_token]
        error!("The reset token expires", 500) if (Time.current - user.reset_password_sent_at) > 15.minutes
        user.password = params[:password]
        user.save
        status 200
      end
    end
  end
end
