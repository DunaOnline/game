class Equipment < ActiveRecord::Base
  attr_accessible :durability, :product_id, :unit_id

	belongs_to :unit
	belongs_to :product
end
