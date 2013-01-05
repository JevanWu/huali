class Shipment
  extend StateMachine::MacroMethods

  state_machine :state, :initial => :ready do
    after_transition :to => :completed, :do => :confirm_order
    after_transition :to => :shipped, :do => :ship_order

    # use adj. for state with future vision
    # use v. for event name
    state :ready do
      transition :to => :shipped, :on => :ship
    end

    # FIXME might need a clock to timeout the processing
    # Might need a bad path for it
    state :shipped do
      transition :to => :completed, :on => :accept
      transition :to => :unknown, :on => :time_out
    end

    state :unknown do
      transition :to => :completed, :on => :accept
    end
  end

  private

  def ship_order
    self.order.ship
  end

  def confirm_order
    self.order.confirm
  end
end
