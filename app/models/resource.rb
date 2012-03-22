class Resource < ActiveRecord::Base
  attr_accessible :user_id, :field_id, :population, :material
  
  belongs_to :field
end
