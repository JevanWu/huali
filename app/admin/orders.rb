# encoding: utf-8
ActiveAdmin.register Order do
  # i18n isn't evaluated here
  menu parent: '订单', priority:1, unless: proc { cannot? :read, Page }

  controller do
    include ActiveAdminCanCan
    authorize_resource
    helper :orders

    # override methods from **inherited_resource** to specify behavior of controller
    # scoped_collection / resource
    def scoped_collection
      if current_administrator.role == 'supplier'
        selected = (Order.column_names - %w{sender_email sender_phone sender_name total}).join(',')
        Order.select(selected).includes(:transactions, :address, :line_items)
      else
        Order.includes(:transactions, :address, :line_items)
      end
    end

    def resource
      if current_administrator.role == 'supplier'
        selected = (Order.column_names - %w{sender_email sender_phone sender_name total}).join(',')
        @order ||= end_of_association_chain.select(selected).find(params[:id])
      else
        super
      end
    end
  end

  actions :all, :except => :new

  scope :all
  scope :current
  scope :tomorrow
  scope :within_this_week
  scope :within_this_month

  filter :expected_date
  filter :state, :as => :select, :collection =>
  {
    "等待付款" => "generated",
    "结束" => "completed",
    "等待审核" => "wait_check",
    "等待发货" => "wait_ship",
    "已经发货" => "wait_confirm",
    "等待退款" => "wait_refund",
    "取消" => "void"
  }

  filter :address_fullname, :as => :string
  filter :address_phone, :as => :string
  filter :address_province_name, :as => :string
  filter :address_city_name, :as => :string
  filter :address_address, :as => :string

  member_action :pay  do
    order = Order.find_by_id(params[:id])
    order.pay
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:wait_check, :scope => :order)
  end

  member_action :check  do
    order = Order.find_by_id(params[:id])
    order.check
    redirect_to edit_admin_shipment_path(order.shipment)
  end

  member_action :cancel  do
    order = Order.find_by_id(params[:id])
    order.cancel
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:void, :scope => :order)
  end

  member_action :refund  do
    order = Order.find_by_id(params[:id])
    order.refund
    redirect_to admin_orders_path, :alert => t(:order_state_changed) + t(:void, :scope => :order)
  end

  index do
    selectable_column
    column :state, :sortable => :state do |order|
      status_tag t(order.state, scope: :order), order_state(order)
    end

    column :identifier, :sortable => :identifier

    column :transaction_identifier, :sortable => :id do |order|
      unless order.transactions.first.nil?
        link_to order.transactions.first.identifier, admin_transaction_path(order.transactions.first)
      end
    end

    column :total, :sortable => :id do |order|
      order[:total]
    end

    column :sender_info do |order|
      [order[:sender_name], order[:sender_email], order[:sender_phone]].select { |s| !s.blank? }.join(', ')
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
      row :state do
        status_tag t(order.state, scope: :order), order_state(order)
      end

      row :identifier

      row :order_content do
        order.subject_text
      end

      row :transaction_info do
        unless order.transactions.blank?
          order.transactions.map do |transaction|
            paylink = transaction.state == "generated" ? link_to(t('order.pay'), transaction.request_process) : " "
            link_to(transaction.identifier, admin_transaction_path(transaction)) + \
            label_tag(" " + t(transaction.state, :scope => :transaction)) + paylink
          end.join('</br>').html_safe
        end
      end

      row :shipment_info do
        unless order.shipments.blank?
          order.shipments.map do |shipment|
            link_to(shipment.identifier, admin_shipment_path(shipment)) + \
            label_tag(" " + t(shipment.state, :scope => :shipment))
          end.join('</br>').html_safe
        end
      end

      row :images do
        order.products.map do |product|
          image_tag product.img(:medium)
        end.join('</br>').html_safe
      end

      row :expected_date

      row :delivery_date

      row :ship_method do
        order.shipment.try(:ship_method)
      end

      row :receiver_info do
        order.address.full_addr
      end

      row :receiver_fullname do
        order.address.fullname
      end

      row :receiver_phonenum do
        order.address.phone
      end

      row :gift_card_text
      row :special_instructions

      row :total do
        number_to_currency order[:total].presence, :unit => '&yen;'
      end

      row :sender_name do
        order[:sender_name].presence
      end

      row :sender_email do
        order[:sender_email].presence
      end

      row :sender_phone do
        order[:sender_phone].presence
      end
    end
  end
end
