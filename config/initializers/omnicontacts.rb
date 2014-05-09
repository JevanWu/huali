require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, ENV['GMAIL_CLIENT_ID'], ENV['GMAIL_CLIENT_SECRET'], { redirect_path: "/contact_callback" }
end
