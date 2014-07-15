class WechatsController < ApplicationController

  def pay
    @appid = Wechat::ParamsGenerator.get_appid
    @timestamp = Wechat::ParamsGenerator.get_timestamp
    @nonce_str = Wechat::ParamsGenerator.get_nonce_str
    @package = Wechat::ParamsGenerator.get_package
    @sign_type = Wechat::ParamsGenerator.get_signtype
    @sign = Wechat::ParamsGenerator.get_sign(@nonce_str, @package, @timestamp)
  end
end
