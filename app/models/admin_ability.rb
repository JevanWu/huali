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
      can :manage, [Product, Collection, Order, Transaction, Refund, Shipment, Coupon, DefaultRegionRule, DefaultDateRule, PeriodRegionPolicy, SlidePanel, Setting]
      cannot :update_seo, [Product, Collection]
      can :record_back_order, Order
      can :read, [PrintGroup, PrintOrder]
    when "product_manager"
      can :manage, [Product, Collection, Asset]
      cannot :update_seo, [Product, Collection]
    when "web_operation_manager"
      can :manage, [Page, Product, Collection, Coupon, Asset, Setting, Story, Banner, SlidePanel]
      can :update_seo, [Product, Collection]
      manage_blog
    when "marketing_manager"
      can :manage, [Coupon, Story, SlidePanel, DailyPhrase]
      can :record_back_order, Order
      can :update, [Order], kind: 'marketing'
      can :read, [Product]
      manage_blog
    when "customer_service"
      can :read, [Coupon]
      can :manage, [Product, Collection, Order, Transaction, Refund, Shipment]
      can :manage, [DefaultRegionRule, DefaultDateRule, PeriodRegionPolicy]
      can :read, [PrintGroup, PrintOrder]
    end

    if user.persisted?
      can :read, ActiveAdmin::Page, :name => "Dashboard"
      can :read, Order
      cannot :destroy, :all unless user.role == "super"

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
