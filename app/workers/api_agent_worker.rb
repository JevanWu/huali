class ApiAgentWorker
  include Sidekiq::Worker
  sidekiq_options queue: :api_agent, backtrace: true

  class << self
    def cancel_order(kind, merchant_order_no)
      api_client.cancel_order(kind, merchant_order_no)
    end

    def update_receiver_address(kind, merchant_order_no, options)
      api_client.update_receiver_address(kind, merchant_order_no, options.symbolize_keys)
    end

    def ship_order(kind, merchant_order_no, ship_method_id, tracking_num = nil)
      api_client.ship_order(kind, merchant_order_no, ship_method_id, tracking_num)
    end

    def check_order(kind, merchant_order_no)
      api_client.check_order(kind, merchant_order_no)
    end

    def sync_order(kind, merchant_order_no)
      api_client.sync_order(kind, merchant_order_no)
    end

  private
    def api_client
      @@api_client ||= Huali::Client.new(api_access_id: 'huali_agent',
                                         api_signing_secret: ENV['API_SIGNING_SECRET'],
                                         endpoint: ENV['AGENT_API_ENDPOINT'])
    end
  end
end
