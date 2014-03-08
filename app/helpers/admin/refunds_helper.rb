module Admin
  module RefundsHelper
    def refund_state_class(refund)
      case refund.state
      when 'pending'
        'warning'
      when 'accepted'
        'ok'
      when 'rejected'
        'error'
      else
      end
    end
  end
end
