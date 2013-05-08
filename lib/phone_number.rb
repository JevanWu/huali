class PhoneNumber
  attr_reader :number

  def initialize(str)
    @number = normalize(str)
  end

  def domestic?
    ! international?
  end

  def international?
    hk? || us? || uk? || au? || no? || de? || it? || sg? || fr?
  end

  def hk?
    @number =~ /^\+?0*852/
  end

  def us?
    @number =~ /^(\+|0+)1/
  end

  def uk?
    @number =~ /^(\+|0+)44/
  end

  def au?
    @number =~ /^(\+|0+)61/
  end

  def no?
    @number =~ /^(\+|0+)47/
  end

  def de?
    @number =~ /^(\+|0+)49/
  end

  def it?
    @number =~ /^(\+|0+)39/
  end

  def sg?
    @number =~ /^(\+|0+)65/
  end

  def fr?
    @number =~ /^(\+|0+)33/
  end

  private

  def normalize(str)
    str.gsub!(/[\s()\-]/, '')
    return str
  end
end
