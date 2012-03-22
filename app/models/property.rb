class Property < ActiveRecord::Base
  attr_accessible :name, :population_bonus, :pop_limit_bonus, :melange_bonus, :material_bonus, :solar_bonus, :exp_bonus, :duration, :population_cost, :melange_cost, :material_cost, :solar_cost, :exp_cost
end
