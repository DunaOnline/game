# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :market do
    area "MyString"
    user_id 1
    price 1
    amount 1.5
  end
end
