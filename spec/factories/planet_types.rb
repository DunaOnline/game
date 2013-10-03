# == Schema Information
#
# Table name: planet_types
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  fields           :integer          default(0)
#  population_bonus :decimal(12, 4)   default(0.0)
#  pop_limit_bonus  :decimal(12, 4)   default(0.0)
#  melange_bonus    :decimal(12, 4)   default(0.0)
#  material_bonus   :decimal(12, 4)   default(0.0)
#  solar_bonus      :decimal(12, 4)   default(0.0)
#  exp_bonus        :decimal(12, 4)   default(0.0)
#  created_at       :datetime
#  updated_at       :datetime
#

FactoryGirl.define do
  factory :planet_type do
    sequence(:name) { |n| "planet_type#{n}" }
    fields 20
  end
end