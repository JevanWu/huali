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
    when "supplier"
      cannot :read, Order
      can :read, Order, state: 'false'
      can [:create, :ship], Shipment
    end
  end
end
