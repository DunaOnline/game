class Unit < ActiveRecord::Base
  attr_accessible :attack, :defence, :description, :equipment, :health, :house_id, :material, :name, :solar, :img

	has_many :products, :through => :equipments
	has_many :equipments
	belongs_to :squad

  scope :house_units, ->(house) { where("house_id = ?", house.id) }
end
