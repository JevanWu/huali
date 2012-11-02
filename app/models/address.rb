class Address < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  belongs_to :area
  attr_accessible :address, :fullname, :phone, :post_code

  validates :fullname, :address, :phone, :presence => true

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
