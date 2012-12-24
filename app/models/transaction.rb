class Transaction < ActiveRecord::Base
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

  private

  def generate_identifier
    self.identifier ||= Time.now.strftime("%Y%m%H%M%S")
  end
end
