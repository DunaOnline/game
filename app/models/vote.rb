class Vote < ActiveRecord::Base
  attr_accessible :house_id, :elector, :elective, :typ
  
  belongs_to :house
  belongs_to :user#, :foreign_key => 'elective'
  
end
