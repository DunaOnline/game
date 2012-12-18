# == Schema Information
#
# Table name: topics
#
#  id             :integer          not null, primary key
#  syselaad_id    :integer          not null
#  user_id        :integer          not null
#  name           :string(255)      not null
#  last_poster_id :integer
#  last_post_at   :datetime
#  created_at     :datetime
#  updated_at     :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :topic do
    sequence(:name) {|n| "topic#{n}"}
    syselaad
    user
  end
end
