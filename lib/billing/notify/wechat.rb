require 'uri'

module Billing
  class Notify
    class Wechat < Base
      include Billing::Helper::Wechat
    end
  end
end
