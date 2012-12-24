class Transaction < ActiveRecord::Base
  attr_accessible :merchant_name, :merchant_trade_no, :amount

  belongs_to :order, :dependent => :destroy

  validates :identifier, :merchant_name, :amount, :presence => true
  validates :identifier, :uniqueness => true
  validates :amount, :numericality => true
  validates_associated :order

  before_validation :generate_identifier

  private

  def generate_identifier
    unless @identifier
      # generate identifier
    end
  end
end
