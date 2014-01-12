class Squad < ActiveRecord::Base
  attr_accessible :field_id, :unit_id, :number

	belongs_to :field
	belongs_to :unit

	def check_move_avail(user,amount,typ="leno")
		poplatok = Constant.presun_leno if typ == "leno"
		poplatok = Constant.presun_planeta if typ == "planeta"
		if user.solar >= amount * poplatok || self.number >= amount
			return true
		else
			return "Nemate dostatok solaru na zaplaceni presunu." if user.solar < amount * poplatok
			return "Nemate dostatek #{self.unit.name} na presun." if self.number < amount
		end
	end

	def attack
		self.unit.attack * self.number
	end

  def defence
	  self.unit.defence * self.number
  end
end
