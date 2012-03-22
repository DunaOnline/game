class PlanetType < ActiveRecord::Base
  attr_accessible :name, :fields, :population_bonus, :pop_limit_bonus, :melange_bonus, :material_bonus, :solar_bonus, :exp_bonus

  has_many :planets
  has_many :discoverables
  
end
