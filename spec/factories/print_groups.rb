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

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :print_group do
    name "MyString"
    ship_method nil
  end
end
