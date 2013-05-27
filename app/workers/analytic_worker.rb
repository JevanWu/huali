# this class is a rewrite of AnalyticsRuby::Consumer
# to enable use sidekiq to handle concurrent batch processing

require 'analytics-ruby/request'

class AnalyticWorker
  include Sidekiq::Worker
  sidekiq_options queue: :analytics, backtrace: true

  @@secret = (Rails.env == 'production' ? ENV['SEGMENTIO_SECRET'] : ENV['SEGMENTIO_DEV_SECRET']).freeze

  class << self
    def open_order(user_id, products, ga_client_id)
      options = {
        user_id: user_id,
        event: 'Opened Order Form',
        properties: {
          category: 'order',
          products: products,
          # FIXME added property to calculate user visits before submit form
          # visited_pages_count: 2
        },
        context: {
          'Google Analytics' => {
            clientId: ga_client_id
          }
        }
      }
      track(options)
    end

    def fill_order(order_id, ga_client_id)
      order = Order.find order_id
      options = {
        user_id: order.user_id,
        event: 'Filled Order Form',
        properties: {
          category: 'order',
          revenue: order.payment_total,
          coupon_code: order.coupon_code,
          province: order.province_name,
          city: order.city_name,
          source: order.source,
          products: order.product_names,
          categories: order.category_names,
          paymethod: order.paymethod
        },
        timestamp: order.created_at,
        context: {
          'Google Analytics' => {
            clientId: ga_client_id
          }
        }
      }
      track(options)
    end

    def complete_order(order_id, ga_client_id)
      order = Order.find order_id
      options = {
        user_id: order.user_id,
        event: 'Completed Order Payment',
        properties: {
          category: 'order',
          revenue: order.payment_total,
          coupon_code: order.coupon_code,
          province: order.province_name,
          city: order.city_name,
          source: order.source,
          products: order.product_names,
          categories: order.category_names,
          paymethod: order.paymethod
        },
        timestamp: order.created_at,
        context: {
          'Google Analytics' => {
            clientId: ga_client_id
          }
        }
      }
      track(options)
    end

    # public: Tracks an event
    #
    # options - Hash
    #           :event      - String of event name.
    #           :user_id    - String of the user id.
    #           :properties - Hash of event properties. (optional)
    #           :timestamp  - Time of when the event occurred. (optional)
    #           :context    - Hash of context. (optional)
    def track(options)

      check_secret

      event = options[:event]
      user_id = options[:user_id].to_s
      properties = options[:properties] || {}
      timestamp = options[:timestamp] || Time.new
      context = options[:context] || {}

      ensure_user(user_id)
      check_timestamp(timestamp)

      if event.nil? || event.empty?
        fail ArgumentError, 'Must supply event as a non-empty string'
      end

      fail ArgumentError, 'Properties must be a Hash' unless properties.is_a? Hash

      add_context(context)

      send_request({ event:      event,
                     userId:     user_id,
                     context:    context,
                     properties: properties,
                     timestamp:  timestamp.iso8601,
                     action:     'track' })
    end

    # public: Identifies a user
    #
    # options - Hash
    #           :user_id   - String of the user id
    #           :traits    - Hash of user traits. (optional)
    #           :timestamp - Time of when the event occurred. (optional)
    #           :context   - Hash of context. (optional)
    def identify(options)

      check_secret

      user_id = options[:user_id].to_s
      traits = options[:traits] || {}
      timestamp = options[:timestamp] || Time.new
      context = options[:context] || {}

      ensure_user(user_id)
      check_timestamp(timestamp)

      fail ArgumentError, 'Must supply traits as a hash' unless traits.is_a? Hash

      add_context(context)

      send_request({ userId:    user_id,
                     context:   context,
                     traits:    traits,
                     timestamp: timestamp.iso8601,
                     action:    'identify' })
    end

    # public: Aliases a user from one id to another
    #
    # options - Hash
    #           :from      - String of the id to alias from
    #           :to        - String of the id to alias to
    #           :timestamp - Time of when the alias occured (optional)
    #           :context   - Hash of context (optional)
    def alias(options)

      check_secret

      from = options[:from].to_s
      to = options[:to].to_s
      timestamp = options[:timestamp] || Time.new
      context = options[:context] || {}

      ensure_user(from)
      ensure_user(to)
      check_timestamp(timestamp)

      add_context(context)

      send_request({ from:      from,
                     to:        to,
                     context:   context,
                     timestamp: timestamp.iso8601,
                     action:    'alias' })
    end

    private

    # private: send the request
    #
    # returns the response object
    def send_request(action)
      # segment.io API requires actions in batch
      batch = [action]
      Rails.logger.debug "Creating Analytic #{action[:action]}: #{action.inspect}"
      req = AnalyticsRuby::Request.new
      res = req.post(@@secret, batch)
      raise "#{res.status}: #{res.error}" unless res.status == 200
      return true
    end

    # private: Ensures that a user id was passed in.
    #
    # user_id    - String of the user id
    #
    def ensure_user(user_id)
      fail ArgumentError, 'Must supply a non-empty user_id' if user_id.empty?
    end

    # private: Adds contextual information to the call
    #
    # context - Hash of call context
    def add_context(context)
      context[:library] = 'analytics-ruby'
    end

    # private: Checks that the secret is properly initialized
    def check_secret
      fail 'Secret must be initialized' if @@secret.nil?
    end

    # private: Checks the timstamp option to make sure it is a Time.
    def check_timestamp(timestamp)
      fail ArgumentError, 'Timestamp must be a Time' unless timestamp.is_a? Time
    end
  end
end
