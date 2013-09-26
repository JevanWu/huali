class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Administrator.new

    case user.role
    when "super"
      can :manage, :all
    when "admin"
      can :manage, :all
      cannot :manage, Administrator
      cannot :manage, Sidekiq
      cannot :destroy, :all
    when "operation_manager"
      can :manage, [Product, Collection, Order, Transaction, Shipment, Coupon, DefaultRegionRule, DefaultDateRule]
      cannot :bulk_export_data, [Product, Order, Transaction, Shipment]
      cannot :destroy, :all
      cannot :update_seo, [Product, Collection]
    when "product_manager"
      can :manage, [Product, Collection, Asset]
      can :read, Order
      cannot :destroy, :all
      cannot :update_seo, [Product, Collection]
    when "web_operation_manager"
      can :manage, [Page, Product, Collection, Coupon, Asset, Setting]
      can :read, Order
      cannot :destroy, :all
      can :update_seo, [Product, Collection]
    when "marketing_manager"
      can :manage, [Coupon]
      can :read, Order
      can :record_back_order
      cannot :destroy, :all
    end
  end
end
