class Ship < ActiveRecord::Base
  attr_accessible :attack, :defence, :description, :equipment, :health, :material, :name, :population, :salary, :solar

	has_many :orbits

  def celkovy_pocet(user)
	  n = 0
	 user.orbits.where(:unit_id => self.id).each do |o|
		 n += o.number
	 end
	  n
  end

end
