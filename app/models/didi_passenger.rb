class DidiPassenger < ActiveRecord::Base
  include Phonelib::Extension

  belongs_to :coupon_code

  validates :phone, presence: true
  phoneize :phone
  validates :phone, phone: { allow_blank: true }

  attr_accessor :terms_of_service

  validates :terms_of_service, acceptance: true
end
