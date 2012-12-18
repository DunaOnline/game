# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  topic_id   :integer          not null
#  user_id    :integer          not null
#  content    :text             not null
#  created_at :datetime
#  updated_at :datetime
#

# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :post do
    sequence(:content) {|n| "posts content#{n}"}
    topic
    user
  end
end
