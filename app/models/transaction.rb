# == Schema Information
#
# Table name: transactions
#
#  amount            :decimal(8, 2)
#  body              :text
#  client_ip         :string(255)
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
#  use_huali_point   :boolean          default(FALSE)
#
# Indexes
#
#  index_transactions_on_identifier  (identifier) UNIQUE
#  index_transactions_on_order_id    (order_id)
#

class Transaction < ActiveRecord::Base
  belongs_to :order
  has_one :user, through: :order
  has_one :point_transaction

  before_validation :generate_identifier, on: :create

  validates_presence_of :order, :identifier, :paymethod, :merchant_name, :amount, :subject
  validates :identifier, uniqueness: true
  validates :amount, numericality: true
  validates :paymethod, inclusion: {
    in: %w(paypal directPay bankPay wechat),
    message: "%{value} is not a valid paymethod."
  }

  validates :merchant_name, inclusion: {
    in: %w(Alipay Paypal Tenpay ICBCB2C CMB CCB BOCB2C ABC COMM CMBC),
    message: "%{value} is not a valid merchant name."
  }

  validates :merchant_trade_no, uniqueness: { scope: :order_id }, allow_blank: true

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

  def request_path
    "#{Billing::Base.new(:gateway, self)}"
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

    if processed? or complete_deal(result.trade_no)
      return self
    else
      return false
    end
  end

  def complete_deal(trade_no = nil)
    if complete
      self.processed_at = Time.now
      self.merchant_trade_no = trade_no if trade_no.present?
      save!
    end
  end

  def processed?
    !! processed_at
  end

  def merchant_trade_link
    "#{Billing::Base.new(:link, self)}"
  end

  def finished?
    ["completed"].include?(state)
  end

  def commission_fee
    case paymethod
    when 'paypal'
      0
    when 'wechat'
      amount * 0.02
    else # Alipay
      amount * 0.005
    end
  end

  private

  def generate_identifier
    self.identifier = uid_prefixed_by('TR')
  end

  def notify_order
    self.order.pay!
  end

end
