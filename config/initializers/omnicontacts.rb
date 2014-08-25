require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, ENV['GMAIL_CLIENT_ID'], ENV['GMAIL_CLIENT_SECRET'], { redirect_path: "/contact_callback" }
  importer :hotmail, ENV['HOTMAIL_CLIENT_ID'], ENV['HOTMAIL_CLIENT_SECRET'], { redirect_path: "/contact_callback"}
end
