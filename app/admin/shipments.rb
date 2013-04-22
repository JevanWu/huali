# encoding: utf-8
ActiveAdmin.register Shipment do
  menu parent: '订单', if: proc { authorized? :read, Shipment }

  controller do
    helper :shipments
  end

  batch_action :destroy, false

  filter :identifier
  filter :ship_method
  filter :tracking_num
  filter :state, as: :select, collection: {准备: "ready", 发货: "shipped", 未知: "unknown"}
  filter :note

  index do
    selectable_column

    column :state, sortable: :state do |shipment|
      status_tag t('models.shipment.state.' + shipment.state), shipment_state_class(shipment)
    end

    column :identifier, sortable: :identifier do |shipment|
      link_to(shipment.identifier, admin_shipment_path(shipment)) + '<br/>'.html_safe + \
      link_to(t(:edit), edit_admin_shipment_path(shipment))
    end

    column :ship_method

    column :tracking_num, sortable: :tracking_num do |shipment|
      link_to shipment.tracking_num, shipment.kuai_100_url
    end

    column :modify_shipment_state do |shipment|
      shipment_state_shift(shipment)
    end
  end

  member_action :ship do
    @shipment = Shipment.find_by_id(params[:id])
    if @shipment.ship
      redirect_to admin_orders_path, alert: t('views.admin.shipment.shipment_state_changed') + t('models.shipment.state.shipped')
    else
      flash[:error] = "货运订单状态更新失败"
      render 'edit', layout: false
    end
  end

  member_action :accept do
    @shipment = Shipment.find_by_id(params[:id])
    if @shipment.accept
      redirect_to admin_shipments_path, alert: t('views.admin.shipment.shipment_state_changed') + t('models.shipment.state.completed')
    else
      flash[:error] = "货运订单状态更新失败"
      render 'edit', layout: false
    end
  end

  member_action :print do
    @shipment = Shipment.find_by_id(params[:id])
    render 'print', layout: 'plain_print'
  end

  form partial: "form"

  show do

    attributes_table do
      row :state do |shipment|
        status_tag t('models.shipment.state.' + shipment.state), shipment_state_class(shipment)
      end

      row :modify_shipment_state do
        shipment_state_shift(shipment)
      end

      row :order do |shipment|
        link_to(shipment.order.identifier, admin_order_path(shipment.order))
      end

      row :identifier

      row :tracking_num

      row :ship_method

      row :note
    end
  end

end
