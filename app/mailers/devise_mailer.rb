class DeviseMailer < Devise::Mailer
  default from: '"花里花店" <support@postmaster.hua.li>', content_type: 'text/html', css: 'email'
  after_action :set_emailcar_header

  private

    def set_emailcar_header
      headers["X-Scedm-Tid"] = "#{ENV["EMAILCAR_SMTP_USERNAME"]}.#{Time.current.to_i}"
      headers["Reply-To"] = "support@hua.li"
    end
end
