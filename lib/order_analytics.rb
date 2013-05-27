require 'analytics-ruby'
require 'active_support/core_ext/hash/reverse_merge'

class OrderAnalytics
  extend AnalyticsRuby::ClassMethods

  class << self
    def init(options = {})
      on_error = Proc.new { |status, error| Rails.logger.debug "Analytic Track Failed - status: #{status}, error: #{error.inspect}" }
      options.reverse_merge!(on_error: on_error, secret: Rails.env == 'production' ? ENV['SEGMENTIO_SECRET'] : ENV['SEGMENTIO_DEV_SECRET'])
      super(options)
    end

    def track(options)
      Rails.logger.debug "Creating Analytic Track: #{options.inspect}"
      super
    end

    def open_order(user_id, products, ga_client_id)
      init unless @client
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

    def fill_order(order, ga_client_id)
      init unless @client
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

    def complete_order(order, ga_client_id)
      init unless @client
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
  end
end
