class Estate < ActiveRecord::Base
  attr_accessible :building_id, :field_id, :number
  
  belongs_to :field
  belongs_to :building
  
end
