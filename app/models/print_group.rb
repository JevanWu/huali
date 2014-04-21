# == Schema Information
#
# Table name: print_groups
#
#  created_at     :datetime
#  id             :integer          not null, primary key
#  name           :string(255)
#  ship_method_id :integer
#  updated_at     :datetime
#
# Indexes
#
#  index_print_groups_on_name            (name) UNIQUE
#  index_print_groups_on_ship_method_id  (ship_method_id)
#

class PrintGroup < ActiveRecord::Base
  belongs_to :ship_method
  validates :name, uniqueness: true
end
