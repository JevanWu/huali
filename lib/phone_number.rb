class PhoneNumber
  attr_reader :number

  def initialize(str)
    @number = normalize(str)
  end

  def hk?
    @number =~ /^\+?0*852/
  end

  def us?
    @number =~ /^\+?0*1/
  end

  def uk?

  end

  def au?

  end

  def no?

  end

  def de?

  end

  def it?

  end

  def sg?

  end

  def fr?

  end

  private

  def normalize(str)
    str.gsub!(/[\s()\-]/, '')
    return str
  end
end
