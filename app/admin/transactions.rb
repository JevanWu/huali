# encoding: utf-8
ActiveAdmin.register Transaction do
  menu if: proc { can?(:manage, Transaction) }
  controller.authorize_resource

  filter :paymethod
  filter :state, :as => :select, :collection => { "新建" => "generated", "完成" => "completed", "处理中" => "processing", "失败" => "fail" }
  filter :amount

  controller do
    helper :transactions

    def create
      @transaction = Transaction.new(params[:transaction])
      if @transaction.save
        order = Order.find_by_id(@transaction.order_id)
        order.state = "wait_check"
        order.save
        redirect_to admin_transactions_path
      end
    end
  end

  member_action :start do
    transaction = Transaction.find_by_id(params[:id])
    transaction.start
    redirect_to admin_transactions_path, :alert => t(:transaction_state_changed) + t(:processing)
  end

  member_action :complete do
    transaction = Transaction.find_by_id(params[:id])
    transaction.complete
    redirect_to admin_transactions_path, :alert => t(:transaction_state_changed) + t(:completed)
  end

  member_action :fail do
    transaction = Transaction.find_by_id(params[:id])
    transaction.fail
    redirect_to admin_transactions_path, :alert => t(:transaction_state_changed) + t(:failed)
  end

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
    column :modify_transaction_state do |transaction|
      transaction_state_shift(transaction)
    end
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
