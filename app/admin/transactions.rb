# encoding: utf-8
ActiveAdmin.register Transaction do
  #actions :all, :except => :new
  menu :if => proc{ can?(:manage, Transaction) }
  controller.authorize_resource

  index do
    selectable_column

    column :identifier 
    column :merchant_name
    column :merchant_trade_no
    column :paymethod 
    column :amount
    column :state do |transaction|
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
      row :subject
      row :body
    end

    active_admin_comments

  end
end
