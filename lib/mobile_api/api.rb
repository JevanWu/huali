Dir["#{Rails.root}/lib/mobile_api/*.rb"].each {|file| require file}

module MobileAPI
  class API < Grape::API
    version 'v1', using: :path
    format :json

    helpers do
      attr_accessor :current_user

      def authenticate_user!
        user_email = params[:email].presence
        user = user_email && User.find_by(email: user_email)

        if user && Devise.secure_compare(user.authentication_token, params[:token])
          current_user = user
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
