module ShipmentsHelper
  def shipment_state_shift(shipment)
    return if current_admin_ability.cannot? :update, Shipment

    buttons = case shipment.state
    when "ready"
      link_to(t('models.shipment.state.print'), print_admin_shipment_path(shipment), { target: '_blank' }) + \
      link_to(t('models.shipment.state.ship'), ship_admin_shipment_path(shipment),
              data: { confirm: t('views.admin.shipment.confirm_ship',
                                 method: shipment.ship_method,
                                 identifier: shipment.identifier,
                                 tracking_num: shipment.tracking_num
                                )
                    }
             )

    when "shipped"
      link_to(t('models.shipment.state.accept'), accept_admin_shipment_path(shipment))
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
