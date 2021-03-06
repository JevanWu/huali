class AdminAbility
  include CanCan::Ability

  def initialize(user)
    user ||= Administrator.new(role: '')

    case user.role
    when "super"
      can :manage, :all
    when "admin"
      can :manage, :all
      can :read, [Appointment, Transaction, ChangeOrderState, AdminOperation]
      cannot :manage, Administrator, role: 'super'
      cannot :manage, Sidekiq
      cannot :manage_super, Administrator # For use in view
    when "operation_manager"
      can :manage, [Product, Collection, Order, Refund, Shipment, Coupon, DefaultRegionRule, DefaultDateRule, PeriodRegionPolicy, SlidePanel, Setting, SalesChart, DiscountEvent, SyncOrder]
      cannot :update_seo, [Product, Collection]
      can :record_back_order, Order
      can :read, [PrintGroup, PrintOrder, Appointment, Transaction, AdminOperation]
      cannot :manage, ChangeOrderState
    when "product_manager"
      can :manage, [Product, Collection, Asset, SalesChart, SyncOrder, FeaturedProduct, AdminOperation]
      can :read, [Appointment]
      cannot :update_seo, [Product, Collection]
      cannot :manage, ChangeOrderState
    when "web_operation_manager"
      can :manage, [Page, Product, Collection, Coupon, Asset, Setting, Story, Banner, SlidePanel, SalesChart, DiscountEvent, SyncOrder, FeaturedProduct]
      can :read, [Appointment]
      can :update_seo, [Product, Collection, Transaction]
      manage_blog
      cannot :manage, ChangeOrderState
    when "marketing_manager"
      can :manage, [Coupon, Story, SlidePanel, FeaturedProduct, DailyPhrase]
      can :record_back_order, Order
      can :update, [Order], kind: 'marketing'
      can :read, [Product, Appointment]
      manage_blog
      cannot :manage, ChangeOrderState
    when "customer_service"
      can :read, [Coupon]
      can :manage, [Product, Collection, Order, Refund, Shipment, SyncOrder]
      can :manage, [DefaultRegionRule, DefaultDateRule, PeriodRegionPolicy]
      can :read, [PrintGroup, PrintOrder, Appointment, Transaction]
      cannot :manage, ChangeOrderState
    when "customer_service_assistant"
      can :manage, [Order, Shipment]
      can :read, [PrintGroup, PrintOrder, Appointment, Transaction]
      cannot :manage, ChangeOrderState
    end

    if user.persisted?
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :read, Order
      cannot :destroy, :all unless user.role == "super"
      can :destroy, SyncOrder if user.role == 'admin'

      if can? :access, :ckeditor
        can :destroy, [Ckeditor::Picture, Ckeditor::AttachmentFile]
      end

      unless user.role == 'super' || user.role == 'admin'
        cannot :bulk_export_data, :all
      end
    end
  end

  private

  def manage_blog
    can :manage, [BlogCategory, BlogPost]

    # Ckeditor
    can :access, :ckeditor
    can :manage, Ckeditor::Picture
    can :manage, Ckeditor::AttachmentFile
  end
end
