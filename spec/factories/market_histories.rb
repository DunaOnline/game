# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :market_history do
    market_id 1
    amount "9.99"
    user_id 1
  end
end
