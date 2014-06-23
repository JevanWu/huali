# == Schema Information
#
# Table name: postcards
#
#  answer     :string(255)
#  content    :text
#  created_at :datetime
#  id         :integer          not null, primary key
#  identifier :string(255)
#  question   :string(255)
#  updated_at :datetime
#
# Indexes
#
#  index_postcards_on_identifier  (identifier)
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :postcard do
    identifier "MyString"
    content "MyText"
    question "MyString"
    answer "MyString"
  end
end
