# encoding: utf-8

ActiveAdmin.register Transaction do
  menu(:label => "交易")
  #actions :all, :except => :new

  index do
    selectable_column
    column "ID" do |transaction|
      link_to transaction.id, admin_transaction_path(transaction)
    end

    column "交易编号" do |transaction|
      link_to transaction.identifier, admin_transaction_path(transaction)
    end

    column "商户名" do |transaction|
      transaction.merchant_name
    end

    column "支付方式" do |transaction|
      transaction.paymethod
    end

    column "金额" do |transaction|
      transaction.amount
    end

    column "状态" do |transaction|
      transaction.state ? t(transaction.state) : nil
    end

    column "主题" do |transaction|
      transaction.subject
    end

    default_actions
  end

  form :partial => "form"

  show :title => "交易" do |transaction|

    attributes_table do
      row :merchant_name
      row :identifier
      row :paymethod
      row :state do
        transaction.state ? t(transaction.state) : nil
      end
      row :amount
      row :subject
      row :body
    end

    active_admin_comments
  end
end
