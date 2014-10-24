# == Schema Information
#
# Table name: slide_panels
#
#  created_at         :datetime
#  href               :string(255)
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  name               :string(255)
#  priority           :integer
#  updated_at         :datetime
#  visible            :boolean          default(FALSE)
#

# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :story do
    name { Forgery(:lorem_ipsum).word }
    description { Forgery(:lorem_ipsum).words(10) }
    priority 1
    available true
  end
end
