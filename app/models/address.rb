# == Schema Information
#
# Table name: addresses
#
#  address     :string(255)
#  area_id     :integer
#  city_id     :integer
#  created_at  :datetime         not null
#  fullname    :string(255)
#  id          :integer          not null, primary key
#  phone       :string(255)
#  post_code   :string(255)
#  province_id :integer
#  updated_at  :datetime         not null
#  user_id     :integer
#

class Address < ActiveRecord::Base
  attr_accessible :address, :fullname, :phone, :post_code,
                  :province_id, :area_id, :city_id

  belongs_to :province
  belongs_to :city
  belongs_to :area
  belongs_to :user

  has_many :orders
  has_many :shipments

  accepts_nested_attributes_for :province, :area, :city

  before_validation :check_postcode
  validates_presence_of :fullname, :address, :phone, :province, :city
  validate :phone_validate, :location_available

  def check_postcode
    # TODO check the postcode against the prov, city, area postcode
    true
  end

  def to_s
    "#{fullname}: #{address}"
  end

  def full_addr
    [post_code, province.name, city.name, area.try(:name), address].select {|s| !s.blank? }.join(', ')
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

  private

  def phone_validate
    return if phone.blank?
    n_digits = phone.scan(/[0-9]/).size
    valid_chars = (phone =~ /^[-+()\/\s\d]+$/)
    errors.add :phone, :invalid unless (n_digits >= 8 && valid_chars)
  end

  def location_available
    errors.add :province, :unavailable_location if province && !province.available
    errors.add :city, :unavailable_location if city && !city.available
    errors.add :area, :unavailable_location if area && !area.available
  end
end
