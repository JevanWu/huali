require "omnicontacts"

Rails.application.middleware.use OmniContacts::Builder do
  importer :gmail, "582486955899.apps.googleusercontent.com", "sC0kaKpw0AfWOq7lKZWgRj8P", { redirect_path: "/contact_callback" }
end
