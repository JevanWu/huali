module MobileAPI
  class User < Grape::API

    helpers do
    end

    resource :user do

      desc "Return authentication token for identifying current user." 
      params do
        requires :user_email, type: String, desc: "User email."
        requires :user_password, type: String, desc: "User password."
      end
      post :sign_in do
        user = params[:user_email] && User.find_by email: params[:user_email]
        token = user.authentication_token if user.valid_password?(params[:user_password])
        token
      end

      desc "User sign up and return authentication token for identifying current user." 
      params do
        requires :user_email, type: String, desc: "User email."
        requires :user_password, type: String, desc: "User password."
        requires :user_password_confirmation, type: String, desc: "Password confirmation."
        requires :user_name, type: String, desc: "User's name."
        requires :phone, type: String, desc: "User's phone number."
      end
      post :sign_up do
        if params[:user_password] == params[:user_password_confirmation]
          user = User.create(email: params[:user_email], password: params[:user_password], name: params[:user_name],
                             phone: params[:phone]) 
          token = user.authentication_token
        end
        token
      end
    end
  end
end
