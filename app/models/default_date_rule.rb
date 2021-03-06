# == Schema Information
#
# Table name: date_rules
#
#  created_at        :datetime         not null
#  excluded_dates    :text
#  excluded_weekdays :string(255)
#  id                :integer          not null, primary key
#  included_dates    :text
#  name              :string(255)
#  period_length     :string(255)
#  product_id        :integer
#  start_date        :date
#  type              :string(255)
#  updated_at        :datetime         not null
#
# Indexes
#
#  index_date_rules_on_product_id  (product_id)
#



class DefaultDateRule < DateRule
  validates :name, presence: true, uniqueness: true
  has_many :products

  def self.get_product_ids_by(date)
    get_rules_by(date).map(&:product_ids).flatten.select do |p_id|
      Product.find(p_id).local_region_rule.nil?  # because local_date_rule can rewrite default_date_rule
    end
  end
end
