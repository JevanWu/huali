# == Schema Information
#
# Table name: appointments
#
#  created_at     :datetime
#  customer_email :string(255)
#  customer_phone :string(255)
#  id             :integer          not null, primary key
#  notify_at      :datetime
#  product_id     :integer
#  updated_at     :datetime
#  user_id        :integer
#
# Indexes
#
#  index_appointments_on_product_id  (product_id)
#  index_appointments_on_user_id     (user_id)
#

class Appointment < ActiveRecord::Base
  belongs_to :user
  belongs_to :product

  validates :customer_phone, presence: true, if: Proc.new { |a| a.customer_email.nil? }
end
