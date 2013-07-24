class Discount
  attr_reader :operator, :number

  def initialize(adjustment)
    adjust = adjustment.to_s.squeeze(' ').sub('x', '*').sub('%', '/')

    @operator = adjust.first.to_sym if adjust.first.present?
    @number = adjust[1..-1].to_f
  end

  def calculate(amount)
    operator ? amount.send(operator, number) : amount
  end

  def ==(other)
    operator == other.operator && number == other.number
  end
end
