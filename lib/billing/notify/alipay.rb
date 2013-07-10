require 'uri'

module Billing
  class Notify
    class Alipay < Base
      include Billing::Helper::Alipay
    end
  end
end
