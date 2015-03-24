# == Schema Information
#
# Table name: admin_operations
#
#  action           :string(255)
#  administrator_id :integer
#  created_at       :datetime
#  id               :integer          not null, primary key
#  info             :string(255)
#  product_id       :integer
#  result           :string(255)
#  updated_at       :datetime
#
# Indexes
#
#  index_admin_operations_on_administrator_id  (administrator_id)
#  index_admin_operations_on_product_id        (product_id)
#

class AdminOperation < ActiveRecord::Base
  belongs_to :product
  belongs_to :administrator
end
