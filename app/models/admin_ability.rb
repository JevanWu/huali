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
    when "supplier"
      can :read, Order, state: "wait_ship"
      #cannot :read, Order
      #can :read, Order, state: 'wait_ship'
      #can :manage, Shipment
      #cannot :delete, Shipment
    end
  end
end
