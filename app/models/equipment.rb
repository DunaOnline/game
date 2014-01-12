class Equipment < ActiveRecord::Base
  attr_accessible :durability, :product_id, :unit_id
<<<<<<< HEAD
=======

	belongs_to :unit
	belongs_to :product
>>>>>>> origin/Units
end
