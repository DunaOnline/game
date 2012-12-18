# == Schema Information
#
# Table name: syselaads
#
#  id          :integer          not null, primary key
#  house_id    :integer
#  subhouse_id :integer
#  kind        :string(255)      not null
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :syselaad do
    sequence(:name) {|n| "syselaad#{n}"}
    kind "S"
  end
end
