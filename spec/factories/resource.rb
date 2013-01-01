# == Schema Information
#
# Table name: resources
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  field_id   :integer
#  population :decimal(12, 4)   default(0.0)
#  material   :decimal(12, 4)   default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :resource do
    field
    population 100000.0
    material 5000.0
  end
end
