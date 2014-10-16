require 'uri'

module Billing
  module Notify
    class Alipay < Notify::Base
      include Billing::Helper::Alipay
    end
  end
end
