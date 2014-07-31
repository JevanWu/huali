require 'uri'

module Billing
  module Notify
    class Alipay < Base
      include Billing::Helper::Alipay
    end
  end
end
