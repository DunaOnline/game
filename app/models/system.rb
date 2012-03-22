class System < ActiveRecord::Base
  attr_accessible :system_name
  
  has_many :planets, :primary_key => 'system_name', :foreign_key => 'system_name'
end
