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


