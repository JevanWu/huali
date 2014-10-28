module MobileAPI
  module MobileAPIHelpers
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

    def verify_signature! 
      unauthorized! unless valid_signature?
    end

    def unauthorized!
      error!("Invalid signature!", 404)
    end

    def valid_signature?
      return false if Time.now.to_i - request.headers["Timestamp"].to_i > 300
      body = request.body
      md5_body = Digest::MD5.hexdigest(body)
      digest = OpenSSL::Digest.new('sha1')
      data = "content=#{md5_body}&content_type=#{request.headers["ContentType"]}&path=#{request.env["REQUEST_PATH"]}&timesamp=#{request.headers["TimeStamp"]}"
      hmac = OpenSSL::HMAC.hexdigest(digest, ENV['MOBILE_API_KEY'], data)
      return false if hmac != request.headers["Signature"]
      return true
    end
  end
end
