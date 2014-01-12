class Unit < ActiveRecord::Base

  attr_accessible :attack, :defence, :description, :equipment, :health, :house_id, :material, :name, :solar, :melange, :img, :population, :salary

	has_many :products, :through => :equipments
	has_many :equipments

  def celkovy_pocet(user)
	  count = 0
	  Field.lena_s_kasarnou(user).each do |f|
		 count += f.squads.where('number > 0 AND unit_id = ?',self.id).first.number if f.squads.where('number > 0 AND unit_id = ?',self.id).first
	  end
	  count
  end

  def vlastnim(field)
	  s = Squad.where(:unit_id => self.id, :field_id => field.id).first
	  s.number
  end

  scope :house_units, ->(house) { where("house_id IN (?) ", [0, house.id]) }

end
