module MobileAPI
  class Users < Grape::API

    helpers do
    end

    resource :users do

      desc "Return authentication token for identifying current user." 
      params do
        requires :email, type: String, desc: "User email."
        requires :password, type: String, desc: "User password."
      end
      post :sign_in do
        user = User.find_by(email: params[:email])
        token = user.authentication_token if user.valid_password?(params[:password])
        status 200 and return { authentication_token: token }
      end

      desc "User sign up and return authentication token for identifying current user." 
      params do
        requires :email, type: String, desc: "User email."
        requires :password, type: String, desc: "User password."
        requires :name, type: String, desc: "User's name."
        requires :phone, type: String, desc: "User's phone number."
      end
      post :sign_up do
        if params[:user_password] == params[:user_password_confirmation]
          user = User.create(email: params[:user_email], password: params[:user_password], name: params[:user_name],
                             phone: params[:phone]) 
          token = user.authentication_token
        end
        { authentication_token: token }
      end
    end
  end
end
