ActiveAdmin.register SyncOrder do
  menu parent: '订单'

  scope :all, default: true
  scope :current
  scope :yesterday
  scope :within_this_week

  filter :kind, as: :select
  filter :merchant_order_no
  filter :created_at
  filter :updated_at

  index do
    column :administrator
    column :kind
    column :merchant_order_no
    column "订单编号" do |sync_order|
      sync_order.order ? link_to(sync_order.order.identifier, admin_order_path(sync_order.order)) : status_tag('正在同步')
    end
    column :created_at
    column :updated_at
    actions
  end

  form partial: "form"

end
