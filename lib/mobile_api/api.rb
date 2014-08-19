Dir["#{Rails.root}/lib/mobile_api/*.rb"].each {|file| require file}

module MobileAPI
  class API < Grape::API
    version 'v1', using: :path
    format :json

    helpers do

      def current_user
        user ||= sign_in_user
      end

      def sign_in_user
        user_email = params[:email].presence
        return unless user_email.present?
        user = user_email && User.find_by(email: user_email)
        return unless user && Devise.secure_compare(user.authentication_token, params[:token])
        user
      end

      def authenticate_user!
        error!('Sorry! This operation needs you to sign in first!', 500) unless current_user
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
