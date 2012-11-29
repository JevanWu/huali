FactoryGirl.define do
  factory :asset do
    image Rails.root.join('spec/fixtures/sample.jpg').open
    viewable
  end
end
