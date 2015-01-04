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

  after_create :invalidate_old_transactions
  before_validation :generate_identifier, on: :create

  validates_presence_of :order, :identifier, :paymethod, :merchant_name, :amount, :subject
  validates :identifier, uniqueness: true
  validates :amount, numericality: true

  extend Enumerize
  enumerize :paymethod, in: [:paypal, :alipay, :bankPay, :wechat, :wechat_mobile, :cash, :pos, :others]
  enumerize :merchant_name, in: [:JD, :YHD, :Alipay, :Paypal, :Tenpay, :B2B, :ICBCB2C, :CMB, :CCB, :BOCB2C, :ABC, :COMM, :CMBC, :Amazon, :Dangdang, :Secoo]

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

      transition to: :invalid, on: :invalidate
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

    #Processing Paypal IPN
    payment_status = result.try(:payment_status)
    unless payment_status.nil?
      if "Refunded" == payment_status
        refund_deal(result.trade_no)
        return true
      else if !["Completed", "Refunded"].include? payment_status
        return true 
      end
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

  def refund_deal(trade_no = nil)
    self.order.cancel
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
    return 0 if order.kind == 'taobao'
    return (0.05 * amount).round(2) if order.kind == 'tmall'
    return 0 if order.kind != 'normal'

    case paymethod
    when 'paypal'
      0
    when 'wechat'
      (amount * 0.02).round(2)
    else # Alipay
      (amount * 0.009).round(2)
    end
  end

  private

  def generate_identifier
    self.identifier = uid_prefixed_by('TR')
  end

  def notify_order
    self.order.pay!
  end

  def invalidate_old_transactions
    order.transactions.by_state("processing").where("id != ?", self.id).each do |transaction|
      transaction.invalidate!
    end
  end

end
