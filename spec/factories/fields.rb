# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  planet_id  :integer          not null
#  name       :string(255)      not null
#  pos_x      :decimal(, )      default(0.0)
#  pos_y      :decimal(, )      default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :field do
    sequence(:name) {|n| "field#{n}"}
    user
    planet
  end
end
