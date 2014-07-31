module Billing
  module Return
    class Alipay < Base
      include Billing::Helper::Alipay
    end
  end
end
