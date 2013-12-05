module Billing
  class Return
    class Wechat < Base
      include Billing::Helper::Wechat
    end
  end
end
