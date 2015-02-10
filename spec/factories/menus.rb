# == Schema Information
#
# Table name: menus
#
#  available     :boolean          default(TRUE)
#  collection_id :integer
#  created_at    :datetime
#  id            :integer          not null, primary key
#  link          :string(255)
#  name          :string(255)
#  parent_id     :integer
#  priority      :integer
#  updated_at    :datetime
#
# Indexes
#
#  index_menus_on_collection_id  (collection_id)
#



# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :menu do
    name "MyString"
    link "MyString"
    collection nil
    valid false
  end
end
