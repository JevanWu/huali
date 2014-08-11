Dir["#{Rails.root}/lib/mobile_api/*.rb"].each {|file| require file}

module MobileAPI
  class API < Grape::API
    version 'v1', using: :path
    format :json

    helpers do
      def authenticate_user!
        user_email = params[:user_email].presence
        user = user_email && User.find_by(email: user_email)

        if user && Devise.secure_compare(user.authentication_token, params[:user_token])
          sign_in user, store: false
        end
      end
    end

    mount Users
    mount Slides
    mount Products
    mount Phrases
    mount Pages
    mount Collections
    mount Orders
  end
end
