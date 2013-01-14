ActiveAdmin.register Shipment do
  menu if: proc { can? :manage, Shipment }
  controller.authorize_resource

  index do
    selectable_column

    column :tracking_num, :sortable => :tracking_num
    column :cost, :sortable => :cost
    column :state, :sortable => :state do |shipment|
      shipment.state ? t(shipment.state) : nil
    end

    column :modify_shipment_state do |shipment|
      link_to(t(:ship), ship_admin_shipment_path(shipment)) + \
      link_to(t(:accept), accept_admin_shipment_path(shipment))
    end

    default_actions
  end

  member_action :ship do
    shipment = Shipment.find_by_id(params[:id])
    shipment.ship
    redirect_to admin_shipments_path, :alert => t(:shipment_state_changed) + t(:shipped)
  end

  member_action :accept do
    shipment = Shipment.find_by_id(params[:id])
    shipment.accept
    redirect_to admin_shipments_path, :alert => t(:shipment_state_changed) + t(:completed)
  end

  form :partial => "form"

  show do

    attributes_table do
      row :tracking_num
      row :cost
      row :state do
        shipment.state ? t(shipment.state) : nil
      end
      row :note
    end
  end

end
