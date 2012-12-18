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

require 'spec_helper'

describe Post do
  it "update topic's last post after save" do
    user  = create(:user)
    topic = create(:topic, user: user)
    post  = create(:post, topic: topic, user: user)

    expect(topic.last_poster_id).to eq(user.id)
  end
end
