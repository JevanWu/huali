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
  include Rails.application.routes.url_helpers

  attr_accessible :merchant_name, :paymethod, :amount, :subject, :body, :order_id, :state

  belongs_to :order
  has_one :user, through: :order

  before_validation :generate_identifier, on: :create

  validates_presence_of :identifier, :paymethod, :merchant_name, :amount, :subject
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
      # fail is reserved for native method name
      transition :to => :failed, :on => :failure
    end
  end

  class << self
    def by_state(state)
      where(:state => state)
    end

    def return(opts)
      result = Billing::Alipay::Return.new(opts)
      handle_process(result)
    end

    def notify(opts)
      result = Billing::Alipay::Notification.new(opts)
      handle_process(result)
    end

    def handle_process(result)
      unless result.verified? && result.success?
        false
      else
        transaction = find_by_identifier(result.out_trade_no)
        if transaction.processed?
          transaction
        else
          if transaction.check_deal(result)
            transaction.complete_deal(result)
            transaction
          else
            false
          end
        end
      end
    end
  end

  def initialize(opts = {}, pay_info = nil)
    if pay_info
      pay_opts = parse_pay_info(pay_info)
      super opts.merge(pay_opts)
    else
      super opts
    end
  end

  def request_process
    start
    Billing::Alipay::Gateway.new(gateway).purchase_path
  end


  def check_deal(result)
    amount.to_f == result.total_fee.to_f
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

  private

  def gateway
    case paymethod
    when 'directPay'; to_alipay
    when 'paypal'; to_paypal
    when 'bankPay'; to_bankpay
    end
  end

  def to_alipay
    {
      # directPay requires the defaultbank to be blank
      'pay_bank' => 'directPay',
      'defaultbank' => '',
      'out_trade_no' => identifier,
      'total_fee' => amount,
      'subject' => subject,
      'body' => body,
      'return_url' => return_order_url(host: $host),
      'notify_url' => notify_order_url(host: $host)
    }
  end

  def to_bankpay
    {
      'pay_bank' => 'bankPay',
      'out_trade_no' => identifier,
      'total_fee' => amount,
      'defaultbank' => merchant_name,
      'subject' => subject,
      'body' => body,
      'return_url' => return_order_url(host: $host),
      'notify_url' => notify_order_url(host: $host)
    }
  end

  def to_paypal
    # {
      # 'item_name' => product.name,
      # 'amount' => exchange_to_dollar(cost)
    # }
  end

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

  def check_return
    # It checks Notification to valid the returned result
    # - paid amount equals the request amount
    # - the transactionID is the same
  end
end
