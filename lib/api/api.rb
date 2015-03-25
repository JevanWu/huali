Dir["#{Rails.root}/lib/api/*.rb"].each {|file| require file}

module API
  class API < Grape::API
    version 'v1', using: :path

    rescue_from ActiveRecord::RecordNotFound do
      rack_response({'message' => '404 Not found'}.to_json, 404)
    end

    rescue_from Grape::Exceptions::ValidationErrors do |e|
      rack_response({'message' => "400 (Bad request)"}.merge(e.errors).to_json, 400)
    end

    rescue_from :all do |exception|
      #Squash::Ruby.notify exception

      rack_response({'message' => '500 Internal Server Error'}.to_json, 500)
    end

    format :json
    helpers APIHelpers

    mount Orders
    mount Addresses
    mount PrintOrders
  end
end
