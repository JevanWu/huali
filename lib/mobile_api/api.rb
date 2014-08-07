Dir["#{Rails.root}/lib/mobile_api/*.rb"].each {|file| require file}

module MobileAPI
  class API < Grape::API
    version 'v1', using: :path
    format :json

    helpers do
    end

    mount Slides
    mount Products
    mount Phrases
    mount Pages
    mount Collections
  end
end
