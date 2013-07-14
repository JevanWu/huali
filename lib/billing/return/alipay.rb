module Billing
  class Return
    class Alipay < Base
      include Billing::Helper::Alipay
    end
  end
end
