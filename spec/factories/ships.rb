# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :ship do
    name "MyString"
    description "MyString"
    equipment 1
    attack 1
    defence 1
    health 1
    population 1
    material 1.5
    solar 1.5
    salary 1.5
  end
end
