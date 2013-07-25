class Discount
  attr_reader :operator, :number

  def initialize(adjustment)
    unless adjustment =~ %r{\A[+-x*%/][\s\d.]+\z}
      raise "Invalid adjustment string"
    end

    adjust = adjustment.to_s.squeeze(' ').sub('x', '*').sub('%', '/')

    @operator = adjust.first.to_sym
    @number = adjust[1..-1].to_f
  end

  def calculate(amount)
    amount.send(operator, number)
  end

  def ==(other)
    operator == other.operator && number == other.number
  end
end
