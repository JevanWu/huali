# encoding: utf-8
ActiveAdmin.register Transaction do
  menu parent: '订单', if: proc { authorized? :read, Transaction }

  controller do
    helper :transactions

    def edit
      @transaction = Transaction.find_by(id: params[:id])
      if @transaction.finished?
        redirect_to [:admin, @transaction], alert: t('views.admin.transaction.cannot_edit')
      end
    end

    private

    def permitted_params
      params.permit transaction: [:amount, :body, :merchant_name, :merchant_trade_no, :order_id, :paymethod, :subject]
    end

    before_action :authorize_to_update_transaction, only: [:batch_action, :start, :complete, :fail]

    def authorize_to_update_transaction
      current_admin_ability.authorize! :update, Transaction
    end
  end

  filter :identifier
  filter :merchant_trade_no
  filter :paymethod, as: :select, collection: Transaction.paymethod.options
  filter :state, as: :select, collection: { 新建: "generated", 完成: "completed", 处理中: "processing", 失败: "failed" }
  filter :amount

  member_action :start do
    transaction = Transaction.find_by_id(params[:id])
    transaction.start
    redirect_to :back, alert: t('views.admin.transaction.transaction_state_changed') + t('models.transaction.state.processing')
  end

  member_action :complete do
    transaction = Transaction.find_by_id(params[:id])
    transaction.complete
    redirect_to :back, alert: t('views.admin.transaction.transaction_state_changed') + t('models.transaction.state.completed')
  end

  member_action :fail do
    transaction = Transaction.find_by_id(params[:id])
    transaction.failure
    redirect_to :back, alert: t('views.admin.transaction.transaction_state_changed') + t('models.transaction.state.failed')
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

  form partial: "form"

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
      row :commission_fee
      row :subject
      row :body
    end
  end
end
