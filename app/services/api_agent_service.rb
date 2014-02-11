class ApiAgentService
  class << self
    def update_receiver_address(order)
      if ["taobao", "tmall"].include?(order.kind)
        if ["wait_check", "wait_make", "wait_ship"].include?(order.state)
          if address_just_modified?(order)
            options = {
              fullname: order.address.fullname,
              phone: order.address.phone,
              province: order.address.province_name,
              city: order.address.city_name,
              area: order.address.area_name,
              address: order.address.address,
              post_code: order.address.post_code
            }
            ApiAgentWorker.delay.update_receiver_address(order.kind.to_s, order.merchant_order_no, options)
          end
        end
      end
    end

    def cancel_order(order)
      if ["taobao", "tmall"].include?(order.kind)
        ApiAgentWorker.delay.cancel_order(order.kind, order.merchant_order_no)
      end
    end

    def ship_order(order)
      if ["taobao", "tmall"].include?(order.kind)
        shipment = order.shipment
        ApiAgentWorker.delay.ship_order(order.kind.to_s,
                                        order.merchant_order_no,
                                        shipment.ship_method_id,
                                        shipment.tracking_num)
      end
    end

  private

    def address_just_modified?(order)
      (Time.now - order.address.updated_at) < 10
    end
  end
end
