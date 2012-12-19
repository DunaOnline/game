# == Schema Information
#
# Table name: globals
#
#  id         :integer          not null, primary key
#  setting    :string(255)      not null
#  value      :boolean
#  datum      :date
#  slovo      :string(255)
#  cislo      :decimal(12, 4)
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :global do
    sequence(:setting) {|n| "setting#{n}"}
  end
end