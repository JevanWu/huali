class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Administrator.new(role: '')

    case user.role
    when "super"
      can :manage, :all
    when "admin"
      can :manage, :all
      cannot :manage, Administrator, role: 'super'
      cannot :manage, Sidekiq
      cannot :manage_super, Administrator # For use in view
    when "operation_manager"
      can :manage, [Product, Collection, Order, Transaction, Shipment, Coupon, DefaultRegionRule, DefaultDateRule]
      cannot :update_seo, [Product, Collection]
      can :record_back_order, Order
    when "product_manager"
      can :manage, [Product, Collection, Asset]
      cannot :update_seo, [Product, Collection]
    when "web_operation_manager"
      can :manage, [Page, Product, Collection, Coupon, Asset, Setting, Story]
      can :update_seo, [Product, Collection]
    when "marketing_manager"
      can :manage, [Coupon]
      can :record_back_order, Order
    end

    if user.persisted?
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :read, Order
      cannot :destroy, :all unless user.role == "super"

      unless user.role == 'super' || user.role == 'admin'
        cannot :bulk_export_data, :all
      end
    end
  end
end
