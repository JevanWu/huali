# FIXME move to an independent gem
module Gooa
  class Client
    class << self
      def page_track(ga_client_id, url = nil, host = nil, path = nil, title = nil, desc = nil)
        raise ArgumentError, 'no valid url or host/path is set' unless url || (host && path)

        options = {
          cid: ga_client_id,
          dl: url,           # Document location URL
          dh: host,          # Document Host Name
          dp: path,          # Document Path
          dt: title,         # Document Title
          cd: desc           # Content Description
        }

        add_action(options, 'pageview')
        send_request(options)
      end

      def event_track(ga_client_id, category, action, label = nil, value = nil)
        options = {
          cid: ga_client_id,
          ec: category,      # Event Category
          ea: action,        # Event Action
          el: label,         # Event Label
          ev: value          # Event Value
        }

        add_action(options, 'event')
        send_request(options)
      end

      def add_item_track(ga_client_id, transaction_id, name, price = nil, quantity = nil, sku = nil, category = nil, currency = nil)
        options = {
          cid: ga_client_id,
          ti: transaction_id, # Transaction ID. Required.
          in: name,           # Item name. Required.
          ip: price,          # Item price.
          iq: quantity,       # Item quantity.
          ic: sku,            # Item code / SKU.
          iv: category,       # Item variation / category.
          cu: currency        # Currency code.
        }

        add_action(options, 'item')
        send_request(options)
      end

      def transaction_track(ga_client_id, transaction_id, affiliation = nil, revenue = nil, shipping = nil, tax = nil, currency = nil)
        options = {
          cid: ga_client_id,
          ti: transaction_id,   # Transaction ID. Required.
          ta: affiliation,      # Transaction Affiliation
          tr: revenue,          # Transaction Revenue
          ts: shipping,         # Transaction Shipping
          tt: tax,              # ransaction Tax
          cu: currency          # Currency code.
        }

        add_action(options, 'transaction')
        send_request(options)
      end

      def social_track(ga_client_id, action, network, target)
        options = {
          cid: ga_client_id,
          sa: action,        # Social Action. Required.
          sn: network,       # Social Network. Required.
          st: target         # Social Target. Required.
        }

        add_action(options, 'social')
        send_request(options)
      end

      private

      def send_request(options)
        default_options = {
          v: 1,            # Version.
          tid: Rails.env == 'production' ? ENV['GA_TRACKING_ID'] : ENV['GA_TRACKING_ID_DEV'] # Tracking ID / Web property / Property ID.
        }

        action = default_options.merge(options.reject {|k, v| v.nil? })

        check_property_id(action)

        conn = Faraday.new(url: 'http://www.google-analytics.com') do |faraday|
          faraday.request  :url_encoded                          # form-encode POST params
          faraday.response :logger if Rails.env == 'development' # log requests to STDOUT
          faraday.adapter  Faraday.default_adapter               # make requests with Net::HTTP
        end

        res = conn.post do |req|
          req.options[:timeout] = 8
          req.options[:open_timeout] = 3
          req.url('/collect')
          req.body = action
        end

        status = res.status
        error  = res.body["error"]

        raise Faraday::Error, res unless res.success?
      end

      def add_action(options, action)
        unless action.in? ['pageview', 'event', 'item', 'transaction', 'social']
          raise ArgumentError, 'invalid action name'
        end
        options[:t] = action
      end

      def check_property_id(action)
        fail 'must provide google analytics property id' if action[:tid].nil?
      end
    end
  end
end

class GaTrackWorker < Gooa::Client
  include Sidekiq::Worker
  sidekiq_options queue: :analytics, backtrace: true

  class << self
    def order_track(order_id)
      order = Order.find(order_id)
      ga_client_id = order.user.ga_client_id

      transaction_track(ga_client_id, order.identifier, 'hua.li', order.payment_total)

      order.line_items.each do |item|
        add_item_track(ga_client_id, order.identifier, item.name, item.price, item.quantity, item.product_id, item.category_name)
      end
    end

    def user_sign_in_track(user_id)
      user = User.find(user_id)
      ga_client_id = user.ga_client_id

      event_track(ga_client_id, 'User Account', 'Sign In')
    end

    def user_sign_up_track(user_id)
      user = User.find(user_id)
      ga_client_id = user.ga_client_id

      event_track(ga_client_id, 'User Account', 'Sign Up')
    end
  end
end

