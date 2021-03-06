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
#  post_code   :integer
#  province_id :integer
#  updated_at  :datetime         not null
#  user_id     :integer
#
# Indexes
#
#  index_addresses_on_user_id  (user_id)
#

class Address < ActiveRecord::Base
  belongs_to :province
  belongs_to :city
  belongs_to :area
  belongs_to :user

  has_many :orders
  has_many :shipments

  delegate :name, to: :province, prefix: true
  delegate :name, to: :city, prefix: true
  delegate :name, to: :area, prefix: true, allow_nil: true

  #validates_presence_of :fullname, :address, :phone, :province, :city, :post_code

  # after_validation :fill_in_post_code

  def to_s
    "#{fullname}: #{address}"
  end

  def print_addr
    [province.name, city.name, area.try(:name), trimmed_addr].select {|s| !s.blank? }.join(', ')
  end

  def trimmed_addr
    address.gsub(province.name, '').gsub(city.name, '').gsub(fullname, '').strip
  end

  def full_addr
    [post_code, province.name, city.name, area.try(:name), trimmed_addr].select {|s| !s.blank? }.join(', ')
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

  # FIXME, the data is not correct
  def location_code
    # find the closest location
    location = area || city || province
    location.post_code
  end

  private

  def fill_in_post_code
    self.post_code = location_code if self.post_code.blank?
  end
end
