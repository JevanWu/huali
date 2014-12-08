ActiveAdmin.register SyncOrder do
  menu parent: '订单', if: proc { authorized? :manage, SyncOrder }

  member_action :update_order_id, method: :get do
    @sync_order = SyncOrder.find(params[:id])
    unless @sync_order.order_id_already_synced
      ApiAgentService.sync_order(@sync_order.kind.to_s, @sync_order.merchant_order_no)
      sleep 2
    end
    @sync_order.sync_order_check
    redirect_to admin_sync_orders_path, {:notice => "订单同步状态已更新"}
  end

  scope :all, default: true
  scope :current
  scope :yesterday
  scope :within_this_week

  filter :kind, as: :select, collection: SyncOrder.kind.options
  filter :merchant_order_no
  filter :created_at
  filter :updated_at

  index do
    column :administrator
    column :kind do |sync_order|
      sync_order.kind_text
    end
    column :merchant_order_no
    column "同步状态" do |sync_order|
      sync_order.order_id ? status_tag("已同步") : status_tag("正在同步")
    end
    column "订单编号" do |sync_order|
      if sync_order.order_id
        link_to(sync_order.order.identifier, admin_order_path(sync_order.order))
      else
        link_to('点击以重新检查订单同步状态', update_order_id_admin_sync_order_path(sync_order))
      end
    end
    column :created_at
    column :updated_at
    actions
  end

  controller do
    def create
      @sync_order = SyncOrder.new(sync_order_params)
      if @sync_order.order_id_already_synced
        redirect_to admin_sync_orders_path, notice: t('active_admin.sync_order.already_synced')
      end
      if @sync_order.save and ApiAgentService.sync_order(@sync_order.kind.to_s, @sync_order.merchant_order_no)
        sleep 2
        @sync_order.sync_order_check
        redirect_to admin_sync_orders_path, notice: t('active_admin.notice.created')
      else
        redirect_to admin_sync_orders_path, notice: t('active_admin.notice.create_failed')
      end
    end

    private
    def sync_order_params
      params.require(:sync_order).permit(:administrator_id, :kind, :merchant_order_no)
    end
  end

  form partial: "form"
end
