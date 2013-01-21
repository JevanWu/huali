# encoding: utf-8
ActiveAdmin.register Shipment do
  menu parent: '订单', if: proc { can? :read, Shipment }

  controller do
    include ActiveAdminCanCan
    authorize_resource
    helper :shipments
  end

  filter :tracking_num
  filter :state, :as => :select, :collection => {"准备" => "ready", "发货" => "shipped", "未知" => "unknown"}
  filter :note

  member_action :ship do
    shipment = Shipment.find_by_id(params[:id])
    shipment.ship
    redirect_to admin_orders_path, :alert => t(:shipment_state_changed) + t(:shipped, :scope => :shipment)
  end

  member_action :accept do
    shipment = Shipment.find_by_id(params[:id])
    shipment.accept
    redirect_to admin_orders_path, :alert => t(:shipment_state_changed) + t(:completed, :scope => :shipment)
  end

  index do
    selectable_column

    column :state, :sortable => :state do |shipment|
      status_tag t(shipment.state, scope: :shipment), shipment_state_class(shipment)
    end

    column :tracking_num, :sortable => :tracking_num

    default_actions

    column :modify_shipment_state do |shipment|
      shipment_state_shift(shipment)
    end
  end

  member_action :ship do
    @shipment = Shipment.find_by_id(params[:id])
    if @shipment.ship
      redirect_to admin_shipments_path, :alert => t(:shipment_state_changed) + t(:shipped, :scope => :shipment)
    else
      flash[:error] = "货运订单状态更新失败"
      render 'edit', layout: false
    end
  end

  member_action :accept do
    @shipment = Shipment.find_by_id(params[:id])
    if @shipment.accept
      redirect_to admin_shipments_path, :alert => t(:shipment_state_changed) + t(:completed, :scope => :shipment)
    else
      flash[:error] = "货运订单状态更新失败"
      render 'edit', layout: false
    end
  end

  form :partial => "form"

  show do

    attributes_table do
      row :state do |shipment|
        status_tag t(shipment.state, scope: :shipment), shipment_state_class(shipment)
      end

      row :tracking_num

      row :modify_shipment_state do
        shipment_state_shift(shipment)
      end
      row :note
    end
  end

end
