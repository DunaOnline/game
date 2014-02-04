class Ship < ActiveRecord::Base
  attr_accessible :attack, :defence, :description, :equipment, :health, :material, :name, :population, :salary, :solar

	has_many :orbits

  def celkovy_pocet(user)
	  n = 0
	 user.orbits.where(:ship_id => self.id).each do |o|
		 n += o.number
	 end
	  n
  end

	def vlastnim(user,planet)
		o = self.orbits.where(:planet_id => planet.id, :user_id => user.id).first
		if o
			o.number
		else
			0
		end
	end

end
