# == Schema Information
#
# Table name: operations
#
#  id          :integer          not null, primary key
#  user_id     :integer
#  house_id    :integer
#  subhouse_id :integer
#  kind        :string(255)
#  content     :string(255)
#  date        :date             default(Thu, 13 Dec 2012)
#  time        :time             default(2000-01-01 21:48:25 UTC)
#  created_at  :datetime
#  updated_at  :datetime
#

class Operation < ActiveRecord::Base
  attr_accessible :user_id, :house_id, :subhouse_id, :kind, :content, :date, :time
  
  belongs_to :user
  belongs_to :house
  
  # KIND:
  # U = uzivatelska
  # M = malorodni
  # N = narodni
  # I = imperialni
  # L = landsraadska
  # S = systemove
  
  scope :uzivatelske, where(:kind => "U")
  scope :malorodni, where(:kind => "M")
  scope :narodni, where(:kind => "N")
  scope :imperialni, where(:kind => "I")
  scope :landsraadska, where(:kind => "L")
  scope :systemove, where(:kind => "S")
  scope :seradit, order('date DESC, time DESC')
  
end
