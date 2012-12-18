# == Schema Information
#
# Table name: syselaads
#
#  id          :integer          not null, primary key
#  house_id    :integer
#  subhouse_id :integer
#  kind        :string(255)      not null
#  name        :string(255)      not null
#  description :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class Syselaad < ActiveRecord::Base
  attr_accessible :house_id, :subhouse_id, :kind, :name, :description

  belongs_to :house
  has_many :topics, :dependent => :destroy

  # KIND:
  # M = malorodni
  # N = narodni
  # I = imperialni
  # L = landsraadsky
  # S = systemovy
  # E = mezinarodni
  
  
  def most_recent_post
    topic = Topic.first(:order => 'last_post_at DESC', :conditions => ['syselaad_id = ?', self.id])
    return topic
  end

  scope :malorodni, where(:kind => "M")
  scope :narodni, where(:kind => "N")
  scope :imperialni, where(:kind => "I")
  scope :landsraadsky, where(:kind => "L")
  scope :systemovy, where(:kind => "S")
  scope :mezinarodni, where(:kind => "E")

end
