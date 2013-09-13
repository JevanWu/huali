# encoding: utf-8
ActiveAdmin.register Coupon do
  menu parent: '设置', if: proc { authorized? :read, Coupon }

  batch_action :destroy, false

  controller do
    private

    def permitted_params
      params.permit(coupon: [:adjustment, :expires_at, :available_count, :note, :price_condition])
    end
  end

  filter :expires_at
  filter :adjustment
  filter :expired
  filter :available_count
  filter :used_count
  filter :price_condition

  index do
    selectable_column
    column :code
    column :adjustment
    column :expired
    column :available_count
    column :used_count
    column :note
    column :expires_at
    column :price_condition

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :code
      row :adjustment
      row :available_count
      row :used_count
      row :price_condition
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
