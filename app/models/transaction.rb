# == Schema Information
#
# Table name: transactions
#
#  amount            :decimal(8, 2)
#  body              :text
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  identifier        :string(255)
#  merchant_name     :string(255)
#  merchant_trade_no :string(255)
#  order_id          :integer
#  paymethod         :string(255)
#  processed_at      :datetime
#  state             :string(255)      default("generated")
#  subject           :string(255)
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_transactions_on_identifier  (identifier) UNIQUE
#  index_transactions_on_order_id    (order_id)
#

class Transaction < ActiveRecord::Base
  attr_accessible :merchant_name, :paymethod, :amount, :subject, :body, :order_id, :state, :merchant_trade_no

  belongs_to :order
  has_one :user, through: :order

  before_validation :generate_identifier, on: :create

  validates_presence_of :order, :identifier, :paymethod, :merchant_name, :amount, :subject
  validates :identifier, uniqueness: true
  validates :amount, numericality: true
  validates :paymethod, inclusion: {
    in: %w(paypal directPay bankPay),
    message: "%{value} is not a valid paymethod."
  }

  validates :merchant_name, inclusion: {
    in: %w(Alipay Paypal ICBCB2C CMB CCB BOCB2C ABC COMM CMBC),
    message: "%{value} is not a valid merchant name."
  }

  state_machine :state, initial: :generated do
    after_transition to: :completed, do: :notify_order

    # use adj. for state with future vision
    # use v. for event name
    state :generated do
      transition to: :processing, on: :start
    end

    # processing is a state where controls are handed off to gateway now
    # the events are all returned from gateway
    state :processing do
      transition to: :completed, on: :complete
      # fail is reserved for native method name
      transition to: :failed, on: :failure
    end
  end

  scope :by_state, lambda { |state| where(state: state) }

  def initialize(opts = {}, pay_info = nil)
    if pay_info
      pay_opts = parse_pay_info(pay_info)
      super opts.merge(pay_opts)
    else
      super opts
    end
  end

  def request_path
    Billing::Base.new(:gateway, self).purchase_path
  end

  def return(opts)
    result = Billing::Base.new(:return, self, opts)
    process(result)
  end

  def notify(opts)
    result = Billing::Base.new(:notify, self, opts)
    process(result)
  end

  def process(result)
    unless result && result.success?
      return false
    end

    if processed? or complete_deal(result)
      return self
    else
      return false
    end
  end

  def complete_deal(result)
    if complete
      self.processed_at = Time.now
      self.merchant_trade_no = result.trade_no
      save!
    end
  end

  def processed?
    !! processed_at
  end

  def merchant_trade_link
    case paymethod
    when 'paypal'
      "https://www.paypal.com/c2/cgi-bin/webscr?cmd=_view-a-trans&id=#{merchant_trade_no}"
    else
      "https://merchantprod.alipay.com/trade/refund/fastPayRefund.htm?tradeNo=#{merchant_trade_no}&action=detail"
    end
  end

  private

  def generate_identifier
    self.identifier = uid_prefixed_by('TR')
  end

  def parse_pay_info(pay_info)
    case pay_info
    when 'directPay'
      { paymethod: 'directPay', merchant_name: 'Alipay' }
    when 'paypal'
      { paymethod: 'paypal', merchant_name: 'Paypal' }
    else
      { paymethod: 'bankPay', merchant_name: pay_info }
    end
  end

  def notify_order
    self.order.pay
  end
end
