class NullDiscount < Discount
  def initialize
  end

  def calculate(amount)
    amount
  end
end
