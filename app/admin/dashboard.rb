# encoding: utf-8
ActiveAdmin.register_page "Dashboard" do
  menu priority: 1, label: -> { I18n.t("active_admin.dashboard") }
  content :title => proc{ I18n.t("active_admin.dashboard")  } do
    columns do
      column do
        panel "最近进来的订单" do
          table_for Order.order('id desc').limit(5) do
            column("状态")  { |order| status_tag t('models.order.state.' + order.state), order_state(order) }
            column("寄件人姓名")  { |order| link_to(order.sender_name, admin_order_path(order)) }
            column("金额")  { |order| number_to_currency order.item_total }
          end
        end
      end

      column do
        panel "最近登录的用户" do
          table_for User.order('last_sign_in_at desc').limit(5) do
            column("邮箱")  { |user| link_to user.email, admin_user_path(user) }
            column("上次登录时间")  { |user| user.last_sign_in_at }
            column("登录次数")  { |user| user.sign_in_count }
          end
        end
      end

    end
  end
end
