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

class Topic < ActiveRecord::Base
  attr_accessible :syselaad_id, :user_id, :name, :last_poster_id, :last_post_at
  
  belongs_to :syselaad
  belongs_to :user
  has_many :posts, :dependent => :destroy  
  
end
