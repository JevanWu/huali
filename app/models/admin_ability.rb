class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Administrator.new

    alias_action :update_product_seo, :update_collection_seo, :to => :update_seo

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
      cannot :bulk_export_data
      cannot :destroy, :all
      cannot :update_seo
    when "product_manager"
      can :manage, [Product, Collection, Asset]
      cannot :destroy, :all
      cannot :update_seo
    when "web_operation_manager"
      can :manage, [Page, Product, Collection, Coupon, Asset, Setting]
      cannot :destroy, :all
      can :update_seo
    when "marketing_manager"
      can :manage, [Coupon]
      can :record_back_order
      cannot :destroy, :all
    end
  end
end
