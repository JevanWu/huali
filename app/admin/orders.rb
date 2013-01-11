# encoding: utf-8
ActiveAdmin.register Order do
  menu :if => proc{ can?(:manage, Order) }
  controller.authorize_resource
  actions :all, :except => :new

  scope :all
  scope :current
  scope :tomorrow
  scope :within_this_week
  scope :within_this_month

  filter :delivery_date

  member_action :pay  do
    order = Order.find_by_id(params[:id])
    order.pay
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:wait_check)
  end

  member_action :check  do
    order = Order.find_by_id(params[:id])
    order.check
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:wait_ship)
  end

  member_action :ship  do
    order = Order.find_by_id(params[:id])
    order.ship
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:wait_confirm)
  end

  member_action :confirm  do
    order = Order.find_by_id(params[:id])
    order.confirm
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:completed)
  end

  member_action :cancel  do
    order = Order.find_by_id(params[:id])
    order.cancel
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:void)
  end

  member_action :refund  do
    order = Order.find_by_id(params[:id])
    order.refund
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:void)
  end

  index do
    selectable_column
    column :identifier, :sortable => :identifier

    column :transaction_identifier, :sortable => :id do |order|
      unless order.transactions.first.nil?
        link_to order.transactions.first.identifier, admin_transaction_path(order.transactions.first)
      end
    end

    column :total, :sortable => :id

    column :receiver_fullname do |order|
      order.address.fullname
    end

    column :receiver_phonenum do |order|
      order.address.phone
    end

    column :state, :sortable => :status do |order|
      order.state ? t(order.state) : nil
    end

    column :delivery_date, :sortable => :delivery_date

    column :process_order do |order|
      link_to(t(:edit), edit_admin_order_path(order)) + \
      link_to(t(:view), admin_order_path(order)) + \
      link_to(t(:new_transaction), new_admin_transaction_path(:"transaction[order_id]" => order.id)) + \
      link_to(t(:new_shipment), new_admin_shipment_path(:"shipment[order_id]" => order.id))
    end

    column :modify_order_state do |order|
      state_shift(order)
    end
  end

  form :partial => "form"

  show do

    attributes_table do
      row :identifier

      row :total do
        number_to_currency order.total, :unit => '&yen;'
      end

      row :receiver_fullname do
        order.address.fullname
      end

      row :receiver_phonenum do
        order.address.phone
      end

      row :receiver_address do
        order.address.address
      end

      row :receiver_postcode do
        order.address.post_code
      end

      row :order_content do
        order.line_items.map do |line_item|
          label_tag(line_item.product.name, line_item.product.name + " x " + line_item.quantity.to_s)
        end.join('</br>').html_safe
      end

      row :gift_card_text
      row :special_instructions
      row :delivery_date
    end
  end

end
