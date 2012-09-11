FactoryGirl.define do
  factory :administrator do
    email 'example@example.com'
    password 'please'
    password_confirmation 'please'
    # required if the Devise Confirmable module is used
    #     # confirmed_at Time.now
    #       end
    #       end
  end
end
