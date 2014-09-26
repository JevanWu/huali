class DeviseMailer < Devise::Mailer
  default from: '"花里花店" <support@postmaster.hua.li>', content_type: 'text/html', css: 'email'
end
