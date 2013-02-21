module ShipmentsHelper
  def shipment_state_shift(shipment)
    buttons = case shipment.state
    when "ready"
      link_to(t(:ship, :scope => :shipment), ship_admin_shipment_path(shipment),
              confirm: t(:confirm_ship,
                         method: shipment.ship_method, identifier: shipment.identifier, tracking_num: shipment.tracking_num))
    when "shipped"
      link_to(t(:accept, :scope => :shipment), accept_admin_shipment_path(shipment))
    end
    content_tag('div', buttons, id: 'process-buttons')
  end

  def shipment_state_class(shipment)
    case shipment.state
    when 'ready'
      'warning'
    when 'shipped'
      ''
    when 'completed'
      'ok'
    when 'unknown'
      'error'
    else
    end
  end
end
