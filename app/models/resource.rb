# == Schema Information
#
# Table name: resources
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  field_id   :integer
#  population :decimal(12, 4)   default(0.0)
#  material   :decimal(12, 4)   default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Resource < ActiveRecord::Base
  attr_accessible :user_id, :field_id, :population, :material
  
  belongs_to :field
end
