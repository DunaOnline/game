# == Schema Information
#
# Table name: effects
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  population_bonus :decimal(12, 4)   default(0.0)
#  pop_limit_bonus  :decimal(12, 4)   default(0.0)
#  melange_bonus    :decimal(12, 4)   default(0.0)
#  material_bonus   :decimal(12, 4)   default(0.0)
#  solar_bonus      :decimal(12, 4)   default(0.0)
#  exp_bonus        :decimal(12, 4)   default(0.0)
#  duration         :decimal(12, 4)   default(0.0)
#  population_cost  :decimal(12, 4)   default(0.0)
#  melange_cost     :decimal(12, 4)   default(0.0)
#  material_cost    :decimal(12, 4)   default(0.0)
#  solar_cost       :decimal(12, 4)   default(0.0)
#  exp_cost         :decimal(12, 4)   default(0.0)
#  created_at       :datetime
#  updated_at       :datetime
#

class Effect < ActiveRecord::Base
  attr_accessible :name, :population_bonus, :pop_limit_bonus, :melange_bonus, :material_bonus, :solar_bonus, :exp_bonus, :duration, :population_cost, :melange_cost, :material_cost, :solar_cost, :exp_cost
end
