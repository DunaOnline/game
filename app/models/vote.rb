# == Schema Information
#
# Table name: votes
#
#  id         :integer          not null, primary key
#  house_id   :integer          not null
#  elector    :integer          not null
#  elective   :integer          not null
#  typ        :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Vote < ActiveRecord::Base
  attr_accessible :house_id, :elector, :elective, :typ
  
  belongs_to :house
  belongs_to :user#, :foreign_key => 'elective'
  
end
