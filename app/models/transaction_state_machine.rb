class Transaction
  extend StateMachine::MacroMethods

  state_machine :state, :initial => :generated do
    before_transition :to => :completed, :do => :check_return
    after_transition :to => :completed, :do => :notify_order

    # use adj. for state with future vision
    # use v. for event name
    state :generated do
      transition :to => :processing, :on => :start
    end

    # processing is a state where controls are handed off to gateway now
    # the events are all returned from gateway
    # FIXME might need a clock to timeout the processing
    state :processing do
      transition :to => :completed, :on => :complete
      transition :to => :failed, :on => :failure
    end
  end

  private

  def notify_order
    self.order.pay
  end

  def check_return
    # It checks Notification to valid the returned result
    # - paid amount equals the request amount
    # - the transactionID is the same
  end
end
