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
