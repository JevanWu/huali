Dir["#{Rails.root}/lib/mobile_api/*.rb"].each {|file| require file}

module MobileAPI
  class API < Grape::API
    version 'v1', using: :path
    format :json

    #before { verify_signature! }

    helpers MobileAPIHelpers

    mount Users
    mount Slides
    mount Products
    mount Phrases
    mount Pages
    mount Collections
    mount Orders
    mount DailyPhrases
    mount MobileMenus
    mount Stories
  end
end
