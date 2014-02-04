class Orbit < ActiveRecord::Base
  attr_accessible :number, :planet_id, :ship_id, :user_id

	belongs_to :planet
	belongs_to :ship
	belongs_to :user


  def check_ships_move_avail(user, pocet)
	  pocet * Constant.ship_movement_cost <= user.solar
  end


end
