# == Schema Information
#
# Table name: daily_phrases
#
#  created_at         :datetime
#  id                 :integer          not null, primary key
#  image_content_type :string(255)
#  image_file_name    :string(255)
#  image_file_size    :integer
#  image_updated_at   :datetime
#  phrase             :text
#  title              :string(255)
#  updated_at         :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :daily_phrase do
    title "MyString"
    phrase "MyText"
  end
end
