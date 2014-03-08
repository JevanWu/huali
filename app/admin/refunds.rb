# encoding: utf-8
ActiveAdmin.register Refund do
  menu parent: '订单', if: proc { authorized? :read, Refund }

  filter :merchant_refund_id
  filter :order_identifier, as: :string
  filter :transaction_identifier, as: :string
  filter :state, as: :select, collection: { 等待退款: "pending", 已退货: "goods_returned", 已接受: "accepted", 已拒绝: "rejected" }
  filter :tracking_number

  index do
    column :id

    column :state, sortable: :state do |refund|
      status_tag t('models.refund.state.' + refund.state), refund_state_class(refund)
    end

    column :merchant_refund_id

    column :order do |refund|
      link_to refund.order.identifier, admin_order_path(refund.order)
    end

    column :amount

    column :transaction do |refund|
      link_to refund.transaction.identifier, admin_transaction_path(refund.transaction)
    end

    column :reason

    default_actions
  end

  show do

    attributes_table do
      row :state do
        status_tag t('models.refund.state.' + refund.state), refund_state_class(refund)
      end

      row :merchant_refund_id

      row :order do
        link_to refund.order.identifier, admin_order_path(refund.order)
      end

      row :amount

      row :transaction do
        link_to refund.transaction.identifier, admin_transaction_path(refund.transaction)
      end

      row :reason
      row :ship_method
      row :tracking_number
    end
  end
end
