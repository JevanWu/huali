# == Schema Information
#
# Table name: pages
#
#  content_en       :text
#  content_zh       :text
#  created_at       :datetime         not null
#  id               :integer          not null, primary key
#  in_footer        :boolean          default(TRUE)
#  meta_description :string(255)
#  meta_keywords    :string(255)
#  meta_title       :string(255)
#  permalink        :string(255)
#  title_en         :string(255)
#  title_zh         :string(255)
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_pages_on_permalink  (permalink)
#

FactoryGirl.define do
  factory :page do
    title_en "Page title"
    title_zh { Forgery(:lorem_ipsum).word }
    content_en "Page content"
    content_zh { Forgery(:lorem_ipsum).paragraph }
    sequence(:permalink) { |n| "page_#{n}" }
    in_footer true
  end
end


