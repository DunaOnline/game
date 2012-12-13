class Post < ActiveRecord::Base
  attr_accessible :topic_id, :user_id, :content
  
  belongs_to :topic
  belongs_to :user
  
end
