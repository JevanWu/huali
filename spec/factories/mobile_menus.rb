# == Schema Information
#
# Table name: mobile_menus
#
#  created_at         :datetime
#  description        :text
#  href               :string(255)
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  priority           :integer
#  updated_at         :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :mobile_menu do
    name "MyString"
    href "MyString"
    priority 1
  end
end
