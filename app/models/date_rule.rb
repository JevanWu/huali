# == Schema Information
#
# Table name: date_rules
#
#  created_at        :datetime         not null
#  end_date          :date
#  excluded_dates    :text
#  excluded_weekdays :string(255)
#  id                :integer          not null, primary key
#  included_dates    :text
#  name              :string(255)
#  product_id        :integer
#  start_date        :date
#  type              :string(255)
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_date_rules_on_product_id  (product_id)
#

class DateRule < ActiveRecord::Base
  attr_accessible :end_date, :excluded_dates, :excluded_weekdays, :included_dates, :start_date, :name

  serialize :included_dates, Array
  serialize :excluded_dates, Array
  serialize :excluded_weekdays, Array
end
