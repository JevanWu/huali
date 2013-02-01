# encoding: utf-8
ActiveAdmin.register Coupon do
  menu parent: '设置', if: proc { can? :read, Coupon }

  controller do
    include ActiveAdminCanCan
    authorize_resource
  end

  batch_action :destroy, false

  filter :expires_at
  filter :adjustment
  filter :used

  index do
    selectable_column
    column :code
    column :adjustment
    column :used
    column :expires_at

    default_actions
  end

  form :partial => "form"

  show do
    attributes_table do
      row :code
      row :adjustment
      row :used
      row :expires_at
    end
  end
end
