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
    column "同步状态"
    column :created_at
    column :updated_at
    actions
  end

end
