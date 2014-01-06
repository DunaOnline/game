class Unit < ActiveRecord::Base
  attr_accessible :attack, :defence, :description, :equipment, :health, :house_id, :material, :name, :solar, :melange, :img

	has_many :products, :through => :equipments
	has_many :equipments
	belongs_to :squad



  scope :house_units, ->(house) { where("house_id IN (?) ", [0, house.id]) }

end
