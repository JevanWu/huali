ActiveAdmin.register User do

  menu priority: 1, if: proc { authorized? :read, User }

  controller do
    def scoped_collection
      User.non_guests
    end

    def permitted_params
      params.permit(user: [:email, :password, :humanizer_answer, :humanizer_question_id])
    end
  end

  filter :email
  filter :created_at

  index do
    selectable_column
    column :email
    column :sign_in_count
    column :last_sign_in_at

    column :created_at do |user|
      l user.created_at, format: :short
    end

    column "订单数量" do |user|
      user.orders.count
    end

    default_actions
  end

  form partial: "form"

  show do
    attributes_table do
      row :email
      row :created_at
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
