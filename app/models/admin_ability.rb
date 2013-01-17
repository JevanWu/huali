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
      cannot :manage, Resque
    when "supplier"
      cannot :read, Order
      cannot :read, Transaction
      can :read, Order, state: 'wait_ship'
      can [:create, :ship], Shipment
    end
  end
end
