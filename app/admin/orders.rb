# encoding: utf-8
ActiveAdmin.register Order do
  # i18n isn't evaluated here
  menu parent: '订单', priority:1, unless: proc { !!authorized?(:read, Order) }

  controller do
    helper :orders

    # override methods from **inherited_resource** to specify behavior of controller
    # scoped_collection / resource
    def scoped_collection
      if current_administrator.role == 'supplier'
        selected = (Order.column_names - %w{sender_email sender_phone sender_name total}).join(',')
        Order.select(selected).includes(:address, :line_items)
      else
        Order.includes(:address, :line_items)
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

    # inherited resource fetch resource through the @order ivar

    def edit
      record = Order.find_by_id(params[:id])

      if record.finished?
        redirect_to [:admin, record], alert: t('views.admin.order.cannot_edit')
      end

      @order = OrderAdminForm.build_from_record(record)
      populate_collection_data
    end

    def update(options = {})
      record = Order.find(params[:id])
      @order = OrderAdminForm.new(params[:order_admin_form])
      @order.bind_record(record)

      if @order.save
        OrderDiscountPolicy.new(@order.record).apply
        ApiAgentService.update_receiver_address(@order.record)

        options[:location] ||= resource_url
        respond_with_dual_blocks(@order, options)
      else
        populate_collection_data
        render active_admin_template('edit')
      end
    end

    private

    before_action :authorize_to_download_orders, only: [:download_latest, :download_all]

    def authorize_to_download_orders
      current_admin_ability.authorize! :bulk_export_data, Order
    end

    def populate_collection_data
      @collection_data = {
        provinces: Province.all.map { |prov| [prov.name, prov.id] },
        cities: Province.find(@order.address.province_id)
                .cities.map { |city| [city.name, city.id] },
        areas: City.find(@order.address.city_id)
                .areas.map { |city| [city.name, city.id] },
        line_items: Product.all.map { |item| [item.name, item.id] }
      }
    end

    def render_excel(orders, filename)
      columns = Order.column_names.map(&:titleize)
      row_data = orders.map { |o| o.attributes.values }

      xlsx = XlsxBuilder.new(columns, row_data).serialize

      send_data xlsx, :filename => "#{filename}", :type => Mime::Type.lookup_by_extension(:xlsx)
    end
  end

  actions :all, except: :new
  batch_action :destroy, false
  batch_action :printed do |selection|
    orders = Order.find(selection)
    orders.each { |o| o.print }
    redirect_to :back, notice: orders.count.to_s + t('views.admin.order.printed')
  end

  batch_action :ship do |selection|
    orders = Order.find(selection)
    failed_shipping_orders = []

    orders.each do |o|
      unless o.shipment && o.shipment.ship
        failed_shipping_orders << o
      end
    end

    if failed_shipping_orders.blank?
      redirect_to :back, notice: t('views.admin.order.shipped', count: orders.size)
    else
      alert_message = "部分订单发货失败, 请分别单独发货, 失败订单: #{failed_shipping_orders.map(&:identifier).join(', ')}"
      redirect_to :back, alert: alert_message
    end
  end

  batch_action :make do |selection|
    orders = Order.find(selection)
    failed_orders = []

    orders.each do |o|
      o.make or failed_orders << o
    end

    if failed_orders.blank?
      redirect_to :back, notice: t('views.admin.order.made', count: orders.size)
    else
      alert_message = "部分订单制作失败, 请分别单独制作, 失败订单: #{failed_orders.map(&:identifier).join(', ')}"
      redirect_to :back, alert: alert_message
    end
  end

  scope :all
  scope :yesterday
  scope :current
  scope :tomorrow
  scope :next_two_day
  scope :within_this_week
  scope :within_this_month

  filter :identifier
  filter :printed, as: :select, collection: { 是: true, 否: false }
  filter :expected_date
  filter :delivery_date
  filter :kind, as: :select, collection: Order.kind.options
  filter :merchant_order_no
  filter :state, as: :select, collection:
  {
    等待付款: 'generated',
    等待审核: 'wait_check',
    等待发货: 'wait_ship',
    等待制作: 'wait_make',
    已经发货: 'wait_confirm',
    等待退款: 'wait_refund',
    取消: 'void',
    退款成功: 'refunded',
    已经完成: 'completed'
  }
  filter :sender_name, as: :string
  filter :address_fullname, as: :string
  filter :address_phone, as: :string
  filter :address_province_name, as: :string
  filter :address_city_name, as: :string
  filter :address_address, as: :string
  filter :ship_method

  member_action :pay  do
    order = Order.find_by_id(params[:id])
    order.pay
    redirect_to admin_orders_path, alert: t('views.admin.order.order_state_changed') + t('models.order.state.wait_check')
  end

  member_action :check do
    order = Order.find_by_id(params[:id])
    if order.check
      redirect_to admin_orders_path, alert: t('views.admin.order.order_state_changed') + t('models.order.state.wait_make')
    else
      @order = OrderAdminForm.build_from_record(order)
      @order.valid?
      # FIXME A quick fix to display order errors
      @order.errors.messages.update(order.errors.messages)

      populate_collection_data
      render active_admin_template('edit'), layout: false
    end
  end

  member_action :make  do
    order = Order.find_by_id(params[:id])
    order.make
    redirect_to :back, alert: t('views.admin.order.order_state_changed') + t('models.order.state.wait_ship')
  end

  member_action :cancel  do
    order = Order.find_by_id(params[:id])
    order.cancel
    redirect_to admin_orders_path, alert: t('views.admin.order.order_state_changed') + t('models.order.state.void')
  end

  member_action :refund  do
    order = Order.find_by_id(params[:id])
    order.refund
    redirect_to admin_orders_path, alert: t('views.admin.order.order_state_changed') + t('models.order.state.void')
  end

  member_action :print_card do
    @order = Order.find_by_id(params[:id])
    render 'print_card', layout: 'plain_print'
  end

  member_action :print_shipment do
    order= Order.find_by_id(params[:id])
    @address = order.address
    begin
      @type = order.ship_method.kuaidi_query_code
      @shipment_id = order.shipment.identifier

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

  index do
    unless current_admin_ability.cannot? :bulk_export_data, Order
      div do
        link_to('Download latest', params.merge(action: :download_latest), class: 'table_tools_button') +
        link_to('Download All', params.merge(action: :download_all), class: 'table_tools_button')
      end
    end

    selectable_column
    column :state, sortable: :state do |order|
      status_tag t('models.order.state.' + order.state), order_state(order)
    end

    column :identifier, sortable: :identifier do |order|
      link_to order.identifier + ', ' + order.id.to_s, admin_order_path(order)
    end

    column :subject_text, sortable: false

    column :ship_method

    column :sender_info do |order|
      [order[:sender_name], order[:sender_email], order[:sender_phone]].select { |s| !s.blank? }.join(', ')
    end

    column :created_at, sortable: :created_at do |order|
      I18n.l order.created_at, format: :short
    end

    column :delivery_date, sortable: :delivery_date

    column :expected_date, sortable: :expected_date

    column :modify_order_state do |order|
      order_state_shift(order)
    end

    column :printed

    column :tracking_num do |order|
      if shipment = order.shipment
        shipment.tracking_num
      end
    end
  end

  form partial: "form"

  show do
    attributes_table do
      row :state do
        status_tag t('models.order.state.' + order.state), order_state(order)
      end

      row :kind_text

      row :printed

      row :modify_order_state do
        order_state_shift(order)
      end

      row :print_order do
        print_order(order)
      end

      row :identifier do |order|
        content_tag('span', order.identifier) + \
        content_tag('span', order.identifier, class: 'barcode35')
      end

      row :last_order do
        associated_order = Order.find_by_identifier(order.last_order)

        if associated_order
          link_to(order.last_order, admin_order_path(associated_order))
        elsif order.last_order.present?
          "#{order.last_order}(无效的订单号)"
        end
      end

      row :merchant_order_no

      row :order_content do
        order.subject_text
      end

      row :transaction_info do
        unless order.transactions.blank?
          order.transactions.map do |transaction|
            link_to(transaction.identifier, admin_transaction_path(transaction)) + \
            label_tag(" " + t('models.transaction.state.' + transaction.state))
          end.join('</br>').html_safe
        end
      end

      row :shipment_info do
        unless order.shipments.blank?
          order.shipments.map do |shipment|
            link_to(shipment.identifier, admin_shipment_path(shipment)) + \
            label_tag(" " + t('models.shipment.state.' + shipment.state))
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

      row :ship_method

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

      row :coupon_code_record do
        if order.coupon_code_record
          link_to(order.coupon_code_record, admin_coupon_path(order.coupon_code_record.coupon))
        end
      end

      row :item_total do
        number_to_currency order.item_total, unit: '&yen;'
      end

      row :adjustment do
        if order.adjustment.present?
          order.adjustment
        else
          order.coupon_code_record.try(:adjustment)
        end
      end

      row :total do
        number_to_currency order.total, unit: '&yen;'
      end

      row :source

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

  collection_action :download_latest, method: :get do
    orders = Order.within_this_week
    xlsx_filename = "latest-orders-since-#{7.days.ago.to_date}.xlsx"

    render_excel(orders, xlsx_filename)
  end

  collection_action :download_all, method: :get do
    orders = Order.all
    xlsx_filename = "orders-#{Date.current}.xlsx"

    render_excel(orders, xlsx_filename)
  end
end
