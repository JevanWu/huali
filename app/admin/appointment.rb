ActiveAdmin.register Appointment do
  menu parent: '产品', if: proc { authorized? :read, Appointment }
  
  permit_params :customer_phone, :customer_email, :notify_at, :user_id, :product_id

  config.clear_action_items!

  index do
    column :id
    column :product 
    column :customer_phone
    column :customer_email
    column :user
    column :notify_at
    column :created_at
    default_actions
  end
  
end
