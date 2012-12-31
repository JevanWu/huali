class Order
  extend StateMachine::MacroMethods

  state_machine :state, :initial => :generated do
    # TODO implement an auth_state dynamically for each state
    before_transition :to => :wait_refund, :do => :auth_refund

    # use adj. for state with future vision
    # use v. for event name
    state :generated do
      transition :to => :wait_check, :on => :pay
      transition :to => :cancelled, :on => :cancel
    end

    state :wait_check do
      transition :to => :wait_ship, :on => :check
      transition :to => :wait_refund, :on => :cancel
    end

    state :wait_ship do
      transition :to => :wait_confirm, :on => :ship
      transition :to => :wait_refund, :on => :cancel
    end

    state :wait_confirm do
      transition :to => :finished, :on => :confirm
    end

    state :wait_refund do
      transition :to => :cancelled, :on => :refund
    end
  end

  private

  def auth_refund
    # TODO auth the admin for the refund actions
    true
  end
end
