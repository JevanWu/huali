module ShipmentsHelper
  def shipment_state_shift(shipment)
    case shipment.state
    when "ready"
      link_to(t(:ship), start_admin_shipment_path(shipment))
    when "shipped"
      link_to(t(:accept), accept_admin_shipment_path(shipment))
    end
  end
end
