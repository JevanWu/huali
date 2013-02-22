# encoding: utf-8
ActiveAdmin.register Transaction do
  menu parent: '订单', if: proc { can? :read, Transaction }

  controller do
    include ActiveAdminCanCan
    authorize_resource
    helper :transactions
  end

  filter :identifier
  filter :paymethod, :as => :select, :collection => { "Paypal" => "paypal", "支付宝" => "directPay", "网上银行" => "bankPay" }
  filter :state, :as => :select, :collection => { "新建" => "generated", "完成" => "completed", "处理中" => "processing", "失败" => "failed" }
  filter :amount

  member_action :start do
    transaction = Transaction.find_by_id(params[:id])
    transaction.start
    redirect_to :back, :alert => t('views.admin.transaction.transaction_state_changed') + t('models.transaction.state.processing')
  end

  member_action :complete do
    transaction = Transaction.find_by_id(params[:id])
    transaction.complete
    redirect_to :back, :alert => t('views.admin.transaction.transaction_state_changed') + t('models.transaction.state.completed')
  end

  member_action :fail do
    transaction = Transaction.find_by_id(params[:id])
    transaction.failure
    redirect_to :back, :alert => t('views.admin.transaction.transaction_state_changed') + t('models.transaction.state.failed')
  end

  index do
    selectable_column

    column :state, sortable: :state do |transaction|
      status_tag t('models.transaction.state.' + transaction.state), transaction_state_class(transaction)
    end

    column :identifier

    column :order do |transaction|
      link_to transaction.order.identifier, admin_order_path(transaction.order)
    end

    column :paymethod do |transaction|
      t(transaction.paymethod)
    end

    column :amount
    column :merchant_trade_no do |transaction|
      if transaction.merchant_trade_no
        link_to transaction.merchant_trade_no, transaction.merchant_trade_link
      end
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
        status_tag t('models.transaction.state.' + transaction.state), transaction_state_class(transaction)
      end

      row :identifier

      row :order do
        link_to transaction.order.identifier, admin_order_path(transaction.order)
      end

      row :merchant_name

      row :merchant_trade_no do
        if transaction.merchant_trade_no
          link_to transaction.merchant_trade_no, transaction.merchant_trade_link
        end
      end

      row :paymethod do
        t(transaction.paymethod)
      end

      row :modify_transaction_state do
        transaction_state_shift(transaction)
      end

      row :to_pay_link do
        if transaction.state.in? ['processing', 'failed']
          transaction.request_path
        end
      end

      row :amount
      row :subject
      row :body
    end

    active_admin_comments

  end
end
