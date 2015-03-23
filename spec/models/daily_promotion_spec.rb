# == Schema Information
#
# Table name: daily_promotions
#
#  created_at :datetime
#  day        :datetime
#  id         :integer          not null, primary key
#  product_id :integer
#  updated_at :datetime
#
# Indexes
#
#  index_daily_promotions_on_product_id  (product_id)
#

require 'spec_helper'

describe DailyPromotion do
  pending "add some examples to (or delete) #{__FILE__}"
end
