# == Schema Information
#
# Table name: didi_passengers
#
#  coupon_code_id :integer
#  created_at     :datetime
#  id             :integer          not null, primary key
#  name           :string(255)
#  phone          :string(255)
#  updated_at     :datetime
#
# Indexes
#
#  index_didi_passengers_on_coupon_code_id  (coupon_code_id)
#

class DidiPassenger < ActiveRecord::Base
  include Phonelib::Extension

  belongs_to :coupon_code

  validates :phone, presence: true
  phoneize :phone
  validates :phone, phone: { allow_blank: true }

  #attr_accessor :terms_of_service

  #validates :terms_of_service, acceptance: true
end
