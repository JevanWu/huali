FactoryGirl.define do
  factory :survey do
    gender [:male, :female].sample
    receiver_gender [:male, :female].sample
    gift_purpose [:lover, :friend, :client, :older, :other].sample
    user
  end
end

