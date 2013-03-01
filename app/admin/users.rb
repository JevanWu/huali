ActiveAdmin.register User do
  menu priority: 1, if: proc { can? :read, User }
  controller.authorize_resource

  filter :email
  scope :guests
  scope :non_guests
  scope :all

  index do
    selectable_column
    column :email
    column :sign_in_count
    column :last_sign_in_at
    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :email
      row :last_sign_in_at
      row :sign_in_count
      row :orders do
        user.orders.map do |order|
          link_to(order.identifier, admin_order_path(order))
        end.join(' ').html_safe
      end
    end
  end
end
