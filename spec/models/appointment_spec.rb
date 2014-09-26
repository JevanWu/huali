# == Schema Information
#
# Table name: appointments
#
#  created_at :datetime
#  email      :string(255)
#  id         :integer          not null, primary key
#  notify_at  :datetime
#  phone      :string(255)
#  product_id :integer
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_appointments_on_product_id  (product_id)
#  index_appointments_on_user_id     (user_id)
#

require 'spec_helper'

describe Appointment do
  pending "add some examples to (or delete) #{__FILE__}"
end
