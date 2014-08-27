module Billing
  module Return
    class Alipay < Return::Base
      include Billing::Helper::Alipay
    end
  end
end
