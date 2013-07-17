class Discount
  attr_reader :operator, :number

  def initialize(adjustment)
    adjust = adjustment.squeeze(' ').sub('x', '*').sub('%', '/')
    @operator = adjust.first.to_sym
    @number = adjust[1..-1].to_f
  end

  def calculate(amount)
    amount.send(operator, number)
  end
end
