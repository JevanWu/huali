# encoding: utf-8
ActiveAdmin.register Transaction do
  menu if: proc { can?(:manage, Transaction) }
  controller.authorize_resource

  filter :paymethod
  filter :state, :as => :select, :collection =>{ "新建" => "generated", "完成" => "completed", "处理中" => "processing", "失败" => "failure" }
  filter :amount

  scope :generated
  scope :processing
  scope :completed
  scope :failed

  index do
    selectable_column

    column :identifier
    column :order do |transaction|
      link_to transaction.order.identifier, admin_order_path(transaction.order)
    end
    column :paymethod
    column :amount
    column :state, sortable: :state do |transaction|
      transaction.state ? t(transaction.state) : nil
    end
    column :subject
    default_actions
  end

  form :partial => "form"

  show do

    attributes_table do
      row :merchant_name
      row :identifier
      row :paymethod
      row :state do
        transaction.state ? t(transaction.state) : nil
      end
      row :amount
      row :merchant_trade_no
      row :subject
      row :body
    end

    active_admin_comments

  end
end
