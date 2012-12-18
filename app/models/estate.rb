# == Schema Information
#
# Table name: estates
#
#  id          :integer          not null, primary key
#  building_id :integer          not null
#  field_id    :integer          not null
#  number      :integer          default(1), not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Estate < ActiveRecord::Base
  attr_accessible :building_id, :field_id, :number
  
  belongs_to :field
  belongs_to :building
  
end
