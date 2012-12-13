class Topic < ActiveRecord::Base
  attr_accessible :syselaad_id, :user_id, :name, :last_poster_id, :last_post_at
  
  belongs_to :syselaad
  belongs_to :user
  has_many :posts, :dependent => :destroy  
  
end
