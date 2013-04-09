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

  attr_accessible :merchant_name, :paymethod, :amount, :subject, :body, :order_id, :state, :merchant_trade_no

  belongs_to :order
  has_one :user, through: :order

  before_validation :generate_identifier, on: :create
  before_validation :override_merchant_name

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
    before_transition to: :completed, do: :check_return
    after_transition to: :completed, do: :notify_order

    # use adj. for state with future vision
    # use v. for event name
    state :generated do
      transition to: :processing, on: :start
    end

    # processing is a state where controls are handed off to gateway now
    # the events are all returned from gateway
    # FIXME might need a clock to timeout the processing
    state :processing do
      transition to: :completed, on: :complete
      # fail is reserved for native method name
      transition to: :failed, on: :failure
    end
  end

  scope :by_state, lambda { |state| where(state: state) }

  class << self
    def return(customdata, opts)
      case customdata["paymethod"]
      when "directPay", "bankpay"
        result = Billing::Alipay::Return.new(opts)
      when "paypal"
        result = Billing::Paypal::Return.new(opts)
      else
        return false
      end
      handle_process(customdata, result)
    end

    def notify(customdata, opts)
      case customdata["paymethod"]
      when "directPay", "bankpay"
        result = Billing::Alipay::Notification.new(opts)
      when "paypal"
        result = Billing::Paypal::Notification.new(opts)
      else
        return false
      end
      handle_process(customdata, result)
    end

    def handle_process(customdata, result)
      unless result && result.verified? && result.success?
        false
      else
        transaction = find_by_identifier(customdata["identifier"])
        return false unless transaction
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
    request_path
  end

  def request_path
    case paymethod
    when 'paypal'
      Billing::Paypal::Gateway.new(gateway).purchase_path
    else
      Billing::Alipay::Gateway.new(gateway).purchase_path
    end
  end

  def check_deal(result)
    case paymethod
    when 'paypal'
      to_dollar(amount).to_f == result.payment_fee.to_f
    else
      amount.to_f == result.total_fee.to_f
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

  def gateway
    case paymethod
    when 'directPay'; to_alipay
    when 'paypal'; to_paypal
    when 'bankPay'; to_bankpay
    end
  end

  def custom_data
    URI.escape("?customdata=" + {
      paymethod: paymethod,
      identifier: identifier
    }.to_json)
  end

  def to_alipay
    {
      # directPay requires the defaultbank to be blank
      pay_bank: 'directPay',
      defaultbank: '',
      out_trade_no: identifier,
      total_fee: amount,
      subject: subject,
      body: body,
      return_url: return_order_url(host: $host) + custom_data,
      notify_url: notify_order_url(host: $host) + custom_data
    }
  end

  def to_bankpay
    {
      pay_bank: 'bankPay',
      out_trade_no: identifier,
      total_fee: amount,
      defaultbank: merchant_name,
      subject: subject,
      body: body,
      return_url: return_order_url(host: $host) + custom_data,
      notify_url: notify_order_url(host: $host) + custom_data
    }
  end

  def to_paypal
    {
      item_name: subject,
      amount: to_dollar(amount),
      invoice: identifier,
      return: return_order_url(host: $host) + custom_data,
      notify_url: notify_order_url(host: $host) + custom_data
    }
  end

  def to_dollar(amount)
    dollar = amount / 6.0
    # round the dollar amount to 10x
    round = (dollar / 10.0).ceil * 10

    # adjust the number to 5x
    # 124.234 -> 124.99 ; 126.23 -> 129.99
    adjust = (dollar % 10 > 5) ? 0.01 : (5 + 0.01)

    round - adjust
  end

  def override_merchant_name
    case paymethod
    when 'paypal'
      self.merchant_name = 'Paypal'
    when 'directPay'
      self.merchant_name = 'Alipay'
    end
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
