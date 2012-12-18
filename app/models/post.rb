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

class Post < ActiveRecord::Base
  attr_accessible :topic_id, :user_id, :content
  
  belongs_to :topic
  belongs_to :user
  
  after_save :last_post_update
  
  def last_post_update
    self.topic.update_attributes(:last_poster_id => self.user.id, :last_post_at => Time.now)
  end
  
end
