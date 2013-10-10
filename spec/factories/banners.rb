# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :banner do
    name "中秋"
    content "中秋节期间（9月19-22日）仅限上海范围配送，电话客服休息"
    start_date "2013-09-18"
    end_date "2013-09-21"
  end
end
