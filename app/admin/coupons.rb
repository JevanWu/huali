# encoding: utf-8
ActiveAdmin.register Coupon do
  menu parent: '设置', if: proc { authorized? :read, Coupon }

  batch_action :destroy, false

  filter :expires_at
  filter :adjustment
  filter :expired
  filter :available_count
  filter :used_count

  index do
    selectable_column
    column :code
    column :adjustment
    column :expired
    column :available_count
    column :used_count
    column :note
    column :expires_at

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :code
      row :adjustment
      row :available_count
      row :used_count
      row :orders do
        coupon.orders.map do |order|
          link_to(order.identifier, admin_order_path(order))
        end.join(' ').html_safe
      end
      row :note
      row :expired
      row :expires_at
    end
  end
end
