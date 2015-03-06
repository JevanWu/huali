# encoding: utf-8
ActiveAdmin.register_page "Dashboard" do
  controller do
    helper OrdersHelper
  end

  menu priority: 1, label: -> { I18n.t("active_admin.dashboard") }
  content :title => proc{ I18n.t("active_admin.dashboard")  } do
    columns do
      column do
        panel "最近进来的订单" do
          orders = Order.order("created_at DESC")
          paginated_collection(orders.page(params[:orders_page]).per(10), param_name: 'orders_page') do
            table_for collection do |order|
              column("状态")  { |order| status_tag t('models.order.state.' + order.state), order_state(order) }
              column("订单号")  { |order| link_to(order.identifier, admin_order_path(order)) }
              column("产品")  { |order| order.subject_text }
              column("金额")  { |order| number_to_currency order.item_total }
              column("下单时间")  { |order| l order.created_at, format: :short }
            end
          end
        end
      end

      column do
        panel "最近注册的用户" do
          table_for User.non_guests.order('created_at desc').limit(10) do
            column("邮箱")  { |user| link_to user.email, admin_user_path(user) }
            column("注册时间")  { |user| l user.created_at, format: :short }
            column("登录次数")  { |user| user.sign_in_count }
          end
        end
      end
    end
  end
end
