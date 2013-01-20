# encoding: utf-8
ActiveAdmin.register Shipment do
  menu parent: I18n.t('active_admin.menu.order'), if: proc { can? :read, Shipment }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  filter :tracking_num
  filter :state, :as => :select, :collection => {"准备" => "ready", "发货" => "shipped", "未知" => "unknown"}
  filter :cost
  filter :note

  controller do
    helper :shipments
    def create
      @shipment = Shipment.new(params[:shipment])
      if @shipment.save
        order = Order.find_by_id(@shipment.order_id)
        order.state = "wait_confirm"
        order.save
        redirect_to admin_shipments_path
      end
    end
  end

  member_action :ship do
    shipment = Shipment.find_by_id(params[:id])
    shipment.ship
    redirect_to admin_orders_path, :alert => t(:shipment_state_changed) + t(:shipped)
  end

  member_action :accept do
    shipment = Shipment.find_by_id(params[:id])
    shipment.accept
    redirect_to admin_orders_path, :alert => t(:shipment_state_changed) + t(:completed)
  end

  index do
    selectable_column

    column :tracking_num, :sortable => :tracking_num
    column :cost, :sortable => :cost
    column :state, :sortable => :state do |shipment|
      shipment.state ? t(shipment.state) : nil
    end

    default_actions

    column :modify_shipment_state do |shipment|
      shipment_state_shift(shipment)
    end
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
      row :modify_shipment_state do
        shipment_state_shift(shipment)
      end
      row :note
    end
  end

end
