# encoding: utf-8
ActiveAdmin.register Order do
  menu(:label => "订单")
  # batch actions generator
  #{
      #:'生成订单' => :inited!,
      #:'付款' => :paid!,
      #:'发货' => :delivered!,
      #:'收货' => :received!,
      #:'发送确认邮件' => :email_sent!,
      #:'发送物流短信' => :sms_sent!
  #}.each do |label, action|
    #batch_action label do |selection|
      #orders = Order.find(selection)
      #orders.each { |order| order.send(action) }
      #redirect_to :back, :notice => "#{orders.count}张订单已经更新"
    #end
  #end
  #batch_action :destroy, false

  scope :"全部"
  scope :"本月内"
  scope :"今天"
  scope :"明天"
  scope :"本周内"

  filter :delivery_date, :label => "发货时间"
  member_action :pay  do
    order = Order.find(params[:id])
    order.pay
    redirect_to admin_orders_path
  end

  member_action :check  do
    order = Order.find(params[:id])
    order.check
    redirect_to admin_orders_path
  end

  member_action :ship  do
    order = Order.find(params[:id])
    order.ship
    redirect_to admin_orders_path
  end

  member_action :confirm  do
    order = Order.find(params[:id])
    order.confirm
    redirect_to admin_orders_path
  end

  member_action :cancel  do
    order = Order.find(params[:id])
    order.cancel
    redirect_to admin_orders_path
  end

  member_action :refund  do
    order = Order.find(params[:id])
    order.refund
    redirect_to admin_orders_path
  end

  index do
    selectable_column
    column "订单编号", :sortable => :id do |order|
      order.identifier
    end

    column "交易编号", :sortable => :id do |order|
      unless order.transactions.first.nil?
        link_to order.transactions.first.identifier, admin_transaction_path(order.transactions.first)
      end
    end

    column "订单状态", :sortable => :status do |order|
      order.state
    end

    column "订单金额", :sortable => :id do |order|
      order.total
    end

    #column "购买者姓名", :sortable => :buyer_name do |order|
      #order.buyer_name
    #end

    #column "购买者电话", :sortable => :phonenum do |order|
      #order.phonenum
    #end

    column "收货人姓名", :sortable => :phonenum do |order|
      order.address.fullname
    end

    column "收货人电话", :sortable => :phonenum do |order|
      order.address.phone
    end

    column "递送日期", :sortable => :delivery_date do |order|
      order.delivery_date
    end

    column "处理订单" do |order|
      link_to('编辑 ', edit_admin_order_path(order)) + \
      link_to('查看 ', admin_order_path(order)) + \
      link_to('新建交易 ', new_admin_transaction_path(:"transaction[order_id]" => order.id), :confirm => "确定新建一笔交易么?") + \
      link_to('新建递送', new_admin_shipment_path(:"shipment[order_id]" => order.id), :confirm => "确定新建一笔递送么?")
    end

    column "修改订单状态" do |order|
      link_to('付款 ', pay_admin_order_path(order)) + \
      link_to('审核 ', check_admin_order_path(order)) + \
      link_to('发货 ', ship_admin_order_path(order)) + \
      link_to('确认 ', confirm_admin_order_path(order)) + \
      link_to('取消 ', cancel_admin_order_path(order))
    end

  end

  form :partial => "form"

  show :title => "订单" do

    attributes_table do
      row '订单编号' do
        order.identifier
      end

      row '订单总价' do
        order.cal_total.to_s + "元"
      end

      row '收货人姓名' do
        order.address.fullname
      end

      row '收货人电话' do
        order.address.phone
      end

      row '收货人地址' do
        order.address.address
      end

      row '收货人邮编' do
        order.address.post_code
      end

      row :'订单内容' do
        order.line_items.map do |line_item|
          label_tag(line_item.product.name, line_item.product.name + " x " + line_item.quantity.to_s)
          #image_tag line_item.product.assets.first.image.url(:medium)
        end.join('</br>').html_safe
      end


      row '卡片信息' do
        order.gift_card_text
      end

      row '特殊要求' do
        order.special_instructions
      end

      row '递送日期' do
        order.delivery_date
      end

    end
  end

end
