class CountryCode
  COUNTRY_CODES = YAML.load_file(File.expand_path('../../config/country_code.yml', __FILE__))
  attr_reader :code, :calling_code

  def initialize(code, calling_code)
    @code = code
    @calling_code = calling_code
  end

  def name
    "#{calling_code}(#{code})"
  end

  def self.all
    COUNTRY_CODES.map { |k, v| new(k, v) }
  end

  def self.find_by_code(code)
    new *COUNTRY_CODES.find { |k, v| k.to_s == code.to_s }
  end

  def self.default
    find_by_code(Phonelib.default_country)
  end
end
