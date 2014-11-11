ActiveAdmin.register SyncOrder do
  menu parent: '订单'

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
