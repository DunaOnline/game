# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :unit do
    name "MyString"
    house_id 1
    description "MyText"
    attack 1
    defence 1
    health 1
    equipment 1
    material 1.5
    solar 1
  end
end
