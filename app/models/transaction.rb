# == Schema Information
#
# Table name: transactions
#
#  amount            :integer
#  body              :text
#  created_at        :datetime         not null
#  id                :integer          not null, primary key
#  identifier        :string(255)
#  merchant_name     :string(255)
#  merchant_trade_no :string(255)
#  order_id          :integer
#  paymethod         :string(255)
#  processed_at      :datetime
#  status            :string(255)
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

  attr_accessible :merchant_name, :paymethod, :amount, :subject, :body

  belongs_to :order, :dependent => :destroy

  before_validation :generate_identifier, on: :create

  validates :identifier, :paymethod, :merchant_name, :amount, :subject, presence: true
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
  validates_associated :order

  def to_alipay
    {
      'out_trade_no' => self.identifier,
      'total_fee' => self.amount,
      'pay_bank' => self.paymethod,
      'defaultbank' => self.merchant_name,
      'subject' => self.subject,
      'body' => self.body,
      'return_url' => return_order_url(host: 'http://hua.li'),
      'notify_url' => notify_order_url(host: 'http://hua.li')
    }
  end

  def to_paypal

  end

  def generate_identifier
    self.identifier = uid_prefixed_by('TR')
  end
end
