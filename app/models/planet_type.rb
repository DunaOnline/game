# == Schema Information
#
# Table name: planet_types
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  fields           :integer          default(0)
#  population_bonus :decimal(12, 4)   default(0.0)
#  pop_limit_bonus  :decimal(12, 4)   default(0.0)
#  melange_bonus    :decimal(12, 4)   default(0.0)
#  material_bonus   :decimal(12, 4)   default(0.0)
#  solar_bonus      :decimal(12, 4)   default(0.0)
#  exp_bonus        :decimal(12, 4)   default(0.0)
#  created_at       :datetime
#  updated_at       :datetime
#

class PlanetType < ActiveRecord::Base
  attr_accessible :name, :fields, :population_bonus, :pop_limit_bonus, :melange_bonus, :material_bonus, :solar_bonus, :exp_bonus

  has_many :planets
  has_many :discoverables
  
end
