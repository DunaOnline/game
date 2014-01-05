class Squad < ActiveRecord::Base
  attr_accessible :field_id, :unit_id

	belongs_to :field
	belongs_to :unit
end
