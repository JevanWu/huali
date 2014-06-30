# encoding: utf-8
ActiveAdmin.register Shipment do
  menu parent: '订单', if: proc { authorized? :read, Shipment }

  controller do
    helper :shipments

    def create
      @shipment = Shipment.new(permitted_params[:shipment])
      if @shipment.save
        redirect_to print_admin_shipment_path(@shipment) if @shipment.tracking_num?
      else
        render :new
      end
    end

    def update
      @shipment = Shipment.find(params[:id])
      if @shipment.update_attributes(permitted_params[:shipment])
        if !@shipment.tracking_num?
          redirect_to admin_shipment_path(@shipment) and return
        end

        redirect_to print_admin_shipment_path(@shipment) if @shipment.tracking_num?
      else
        render :edit
      end
    end

    private

    def permitted_params
      params.permit shipment: [:order_id, :note, :ship_method_id, :tracking_num]
    end

    before_action :authorize_to_update_shipment, only: [:batch_action, :ship, :accept, :update]

    def authorize_to_update_shipment
      current_admin_ability.authorize! :update, Shipment
    end
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
    @order = Shipment.find_by_id(params[:id]).order
    @address = @order.address
    begin
      @type = @order.ship_method.kuaidi_query_code
      @shipment_id = @order.shipment.identifier

      case @type
      when 'manual'
        render 'admin/shipments/print_blank', layout: 'plain_print'
      else
        render 'admin/shipments/print', layout: 'plain_print'
      end
    rescue NoMethodError
      redirect_to :back, alert: t('views.admin.shipment.cannot_print')
    end
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
