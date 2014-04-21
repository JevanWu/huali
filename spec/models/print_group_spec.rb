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

require 'spec_helper'

describe PrintGroup do
  pending "add some examples to (or delete) #{__FILE__}"
end
