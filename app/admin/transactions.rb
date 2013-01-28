# encoding: utf-8
ActiveAdmin.register Transaction do
  menu parent: '订单', if: proc { can? :read, Transaction }

  controller do
    include ActiveAdminCanCan
    authorize_resource
    helper :transactions
  end

  filter :paymethod
  filter :state, :as => :select, :collection => { "新建" => "generated", "完成" => "completed", "处理中" => "processing", "失败" => "failed" }
  filter :amount

  member_action :start do
    transaction = Transaction.find_by_id(params[:id])
    transaction.start
    redirect_to admin_transactions_path, :alert => t(:transaction_state_changed) + t(:processing, :scope => :transaction)
  end

  member_action :complete do
    transaction = Transaction.find_by_id(params[:id])
    transaction.complete
    redirect_to admin_transactions_path, :alert => t(:transaction_state_changed) + t(:completed, :scope => :transaction)
  end

  member_action :fail do
    transaction = Transaction.find_by_id(params[:id])
    transaction.failure
    redirect_to admin_transactions_path, :alert => t(:transaction_state_changed) + t(:failed, :scope => :transaction)
  end

  index do
    selectable_column

    column :state, sortable: :state do |transaction|
      status_tag t(transaction.state, scope: :transaction), transaction_state_class(transaction)
    end

    column :identifier
    column :order do |transaction|
      link_to transaction.order.identifier, admin_order_path(transaction.order)
    end
    column :paymethod
    column :amount
    column :merchant_trade_no do |transaction|
      merchant_trade_link(transaction)
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
      row :state do
        status_tag t(transaction.state, scope: :transaction), transaction_state_class(transaction)
      end

      row :identifier
      row :merchant_name
      row :merchant_trade_no do
        merchant_trade_link(transaction)
      end

      row :paymethod

      row :modify_transaction_state do
        transaction_state_shift(transaction)
      end

      row :to_pay_link do
        unless transaction.state == "complete"
          link_to t('order.pay'), transaction.request_path
        end
      end

      row :amount
      row :subject
      row :body
    end

    active_admin_comments

  end
end
