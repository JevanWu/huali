class Ability
  include CanCan::Ability

  def initialize(user)
    if user.class.to_s == "Administrator"
      case user.role
      when "super"
        can :manage, :all
      when "admin"
        can :manage, :all
        cannot :manage, Administrator
      when "supplier"
        can :read, Order
        can :ship, Order
      end
    end

    if user.class.to_s == "User"
      case user.role
      when "customer"
        can :read, Order
        can :update, Order
        can :confirm, Order
      end
    end

    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user permission to do.
    # If you pass :manage it will apply to every action. Other common actions here are
    # :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on. If you pass
    # :all it will apply to every resource. Otherwise pass a Ruby class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details: https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
