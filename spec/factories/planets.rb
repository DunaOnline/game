# encoding: utf-8
# == Schema Information
#
# Table name: planets
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  planet_type_id   :integer          not null
#  house_id         :integer
#  system_name      :string(255)
#  position         :integer
#  available_to_all :boolean          default(FALSE)
#  discovered_at    :date             default(Thu, 13 Dec 2012)
#  created_at       :datetime
#  updated_at       :datetime
#

FactoryGirl.define do
  factory :planet do
    sequence(:name) {|n| "planet#{n}"}
    planet_type
    house
  end
end
