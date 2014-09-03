require 'uri'

module Billing
  module Notify
    class WechatMobile < OpenStruct
      include Billing::Helper::Wechat

      def initialize(params)
        super
      end

      def success?
        find_order
        if valid_request? 
          process_order
          true
        else
          false
        end
      end

      private

      def find_order
        @order = Order.find_by identifier: out_trade_no
      end

      def valid_request?
        verified? && right_amount? && trade_state.to_s == "0"
      end

      def process_order
        
        return if @order.paid?

        payment_opts = { paymethod: 'wechat', merchant_name: 'Tenpay' }
        transaction = @order.generate_transaction payment_opts.merge(client_ip: client_ip, paymethod: 'wechat_mobile', merchant_name: 'Tenpay') #TODO: add params[:use_huali_point]
        transaction.update_columns(merchant_trade_no: transaction_id, processed_at: Time.current)
        transaction.start
        transaction.complete 
      end

      def verified?
        # verify_sign && 
        verify_seller
      end

      def verify_seller
        partner == ENV['WECHAT_PARTNERID']
      end

      def right_amount?
        total_fee.to_f == @order.total * 100 # The unit of total_fee is 分
      end

      # def verify_sign
      #   @sign_type ||= @params["sign_type"]
      #   @sign ||= @params["sign"]

      #   # custom_id and sign are excluded in MD5 calculation
      #   query = @params.except('sign', 'trade_no', 'custom_id').sort.map do |key, value|
      #     "#{key}=#{value}"
      #   end.join('&')

      #   Digest::MD5.hexdigest(query + "&key=#{ENV['WECHAT_KEY']}").upcase == @sign
      # end

    end
  end
end
