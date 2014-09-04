module MobileAPI
  class Users < Grape::API

    resource :users do

      desc "Return authentication token for identifying current user." 
      params do
        requires :email, type: String, desc: "User email."
        requires :password, type: String, desc: "User password."
      end
      post :sign_in do
        user = User.find_by(email: params[:email])
        error!('The user does not exist!', 404) if !user.present?
        if user.valid_password?(params[:password])
          token = user.authentication_token
          status 200 and return { authentication_token: token }
        else
          error!("The account and password don't match!", 500)
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
        error!("Invalid password", 400) unless current_user.valid_password?(params[:password])
        current_user.password = params[:new_password]
        current_user.save
        error!(current_user.errors.messages, 500) if current_user.errors.messages.present?
        status 200
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
        current_user.name = params[:name]
        current_user.phone = params[:phone]
        current_user.save
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
    end
  end
end
