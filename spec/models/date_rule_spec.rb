# == Schema Information
#
# Table name: date_rules
#
#  created_at        :datetime         not null
#  end_date          :date
#  excluded_dates    :string(255)
#  excluded_weekdays :string(255)
#  id                :integer          not null, primary key
#  included_dates    :string(255)
#  product_id        :integer
#  start_date        :date
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_date_rules_on_product_id  (product_id)
#

require 'spec_helper'

describe DateRule do
  pending "add some examples to (or delete) #{__FILE__}"
end
