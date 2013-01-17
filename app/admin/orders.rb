# encoding: utf-8
ActiveAdmin.register Order do
  controller.authorize_resource

  actions :all, :except => :new

  scope :all
  scope :current
  scope :tomorrow
  scope :within_this_week
  scope :within_this_month

  filter :delivery_date
  filter :state, :as => :select, :collection => { "新建" => "generated", "结束" => "completed", "等待审核" => "wait_check", "等待确认" => "wait_confirm", "等待发货" => "wait_ship", "等待退款" => "wait_refund", "取消" => "void"  }
  filter :address_fullname, :as => :string
  filter :address_phone, :as => :string
  filter :address_province_name, :as => :string
  filter :address_city_name, :as => :string
  filter :address_address, :as => :string


  controller do
    helper :orders

    def scoped_collection
      Order.includes(:transactions, :address)
    end
  end

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

    column :state, :sortable => :state do |order|
      order.state ? t(order.state) : nil
    end

    column :delivery_date, :sortable => :delivery_date

    column :process_order do |order|
      link_to(t(:edit), edit_admin_order_path(order)) + \
      link_to(t(:view), admin_order_path(order))
    end

    column :modify_order_state do |order|
      order_state_shift(order)
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

      row :receiver_province do
        order.address.province.name
      end

      row :receiver_city do
        order.address.city.name
      end

      row :receiver_address do
        order.address.address
      end

      row :receiver_postcode do
        order.address.post_code
      end

      row :order_content do
        order.subject_text
      end

      row :state do
        t(order.state)
      end

      row :gift_card_text
      row :special_instructions
      row :delivery_date

      row :transaction_info do
        unless order.transactions.blank?
          order.transactions.map do |transaction|
            link_to(transaction.identifier, admin_transaction_path(transaction)) + \
            label_tag(" " + t(transaction.state))
          end.join('</br>').html_safe
        end
      end

      row :shipment_info do
        unless order.shipments.blank?
          order.shipments.map do |shipment|
            link_to(shipment.identifier, admin_shipment_path(shipment)) + \
            label_tag(" " + t(shipment.state))
          end.join('</br>').html_safe
        end
      end

    end
  end

end
