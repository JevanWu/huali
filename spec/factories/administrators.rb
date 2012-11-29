FactoryGirl.define do
  factory :administrator do
    email { Forgery(:internet).email_address }
    password { Forgery(:basic).password }
    password_confirmation { password }
    # confirmed_at Time.now
  end
end
