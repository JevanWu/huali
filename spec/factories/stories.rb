# == Schema Information
#
# Table name: stories
#
#  author_avatar_content_type :string(255)
#  author_avatar_file_name    :string(255)
#  author_avatar_file_size    :integer
#  author_avatar_updated_at   :datetime
#  available                  :boolean
#  created_at                 :datetime
#  description                :string(255)
#  id                         :integer          not null, primary key
#  name                       :string(255)
#  origin_link                :string(255)
#  picture_content_type       :string(255)
#  picture_file_name          :string(255)
#  picture_file_size          :integer
#  picture_updated_at         :datetime
#  priority                   :integer          default(0)
#  product_id                 :integer
#  product_link               :string(255)
#  updated_at                 :datetime
#
# Indexes
#
#  index_stories_on_product_id  (product_id)
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
