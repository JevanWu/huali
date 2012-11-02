class Address < ActiveRecord::Base
  attr_accessible :address, :fullname, :phone, :post_code

  belongs_to :province
  belongs_to :city
  belongs_to :area

  belongs_to :user

  validates :fullname, :address, :phone, :presence => true
  validate :phone_validate

  def phone_validate
    return if phone.blank?
    n_digits = phone.scan(/[0-9]/).size
    valid_chars = (phone =~ /^[-+()\/\s\d]+$/)
    errors.add :phone, :invalid unless (n_digits >= 8 && valid_chars)
  end

  def to_s
    "#{full_name}: #{address}"
  end

  def same_as?(other)
    return false if other.nil?
    attributes.except('id', 'updated_at', 'created_at') == other.attributes.except('id', 'updated_at', 'created_at')
  end

  alias same_as same_as?

  def ==(other_address)
    self_attrs = self.attributes
    other_attrs = other_address.respond_to?(:attributes) ? other_address.attributes : {}

    [self_attrs, other_attrs].each { |attrs| attrs.except!('id', 'created_at', 'updated_at', 'order_id') }

    self_attrs == other_attrs
  end

  def clone
    self.class.new(self.attributes.except('id', 'updated_at', 'created_at'))
  end

end
