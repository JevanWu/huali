# == Schema Information
#
# Table name: slide_panels
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
#  title              :string(255)
#  updated_at         :datetime
#  visible            :boolean          default(FALSE)
#


# Read about factories at https://github.com/thoughtbot/factory_girl
FactoryGirl.define do
  factory :slide_panel do
    name { Forgery(:lorem_ipsum).word }
    href "/"
    priority 1
    visible false
  end
end
