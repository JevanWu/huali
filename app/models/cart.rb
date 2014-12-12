# == Schema Information
#
# Table name: carts
#
#  created_at :datetime
#  id         :integer          not null, primary key
#  price      :decimal(8, 2)    not null
#  product_id :integer
#  quantity   :integer          not null
#  updated_at :datetime
#  user_id    :integer
#
# Indexes
#
#  index_carts_on_product_id  (product_id)
#  index_carts_on_user_id     (user_id)
#

class Cart < ActiveRecord::Base
end
