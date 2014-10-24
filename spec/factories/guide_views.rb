# == Schema Information
#
# Table name: guide_views
#
#  available          :boolean          default(FALSE)
#  created_at         :datetime
#  description        :text
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  priority           :integer
#  updated_at         :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guide_view do
    description "MyString"
  end
end
