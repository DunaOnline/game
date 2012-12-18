# == Schema Information
#
# Table name: houses
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  leader          :string(255)
#  solar           :decimal(12, 4)   default(0.0)
#  melange         :decimal(12, 4)   default(0.0)
#  material        :decimal(12, 4)   default(0.0)
#  exp             :decimal(12, 4)   default(0.0)
#  playable        :boolean          default(TRUE)
#  melange_percent :decimal(12, 4)   default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  influence       :decimal(, )
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :house do
    sequence(:name) {|n| "house#{n}"}
  end
end
