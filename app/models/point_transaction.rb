class PointTransaction < ActiveRecord::Base
  belongs_to :user
  belongs_to :transaction

  validates :transaction_type, inclusion: { in: %w(income, expense), message: "%{value} is not a valid transaction type!" }
end
