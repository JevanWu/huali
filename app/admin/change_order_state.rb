ActiveAdmin.register ChangeOrderState do
  menu parent: "订单", if: proc { authorized? :manage, ChangeOrderState }

  scope :all, default: true
  scope :current
  scope :yesterday
  scope :within_this_week

  filter :order_identifier
  filter :created_at
  filter :updated_at

  index do
    column :administrator
    column "订单号" do |change_order_state|
      link_to change_order_state.order_identifier, admin_order_path(change_order_state.order)
    end
    column "更改前状态" do |change_order_state|
      status_tag(change_order_state.before_state) 
    end
    column "更改后状态" do |change_order_state|
      status_tag(change_order_state.after_state)
    end
  end

  controller do

    def create
      @change_order_state = ChangeOrderState.new(change_order_state_params)
      @order = Order.find_by identifier: @change_order_state.order_identifier
      @change_order_state.before_state = @order.state
      @change_order_state.order = @order

      if @change_order_state.save
        @order.update_column(:state, @change_order_state.after_state)
        redirect_to admin_change_order_states_path
      else
        redirect_to admin_change_order_states_path
      end
    end

    private

    def change_order_state_params
      params.require(:change_order_state).permit(:administrator_id, :order_identifier, :after_state)
    end
  end

  form partial: "form"
end
