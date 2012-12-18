# encoding: utf-8
# == Schema Information
#
# Table name: polls
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  law_id     :integer
#  choice     :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Poll < ActiveRecord::Base
  attr_accessible :choice
  
  belongs_to :user
  belongs_to :law
  
  CHOICE = [
    'Ano',
    'Ne',
    'Zdržuji se'
  ]
  
  scope :pro, where(:choice => Poll::CHOICE[0])
  scope :proti, where(:choice => Poll::CHOICE[1])
  scope :zdrzelo, where(:choice => Poll::CHOICE[2])
  
end
