# == Schema Information
#
# Table name: buildings
#
#  id               :integer          not null, primary key
#  kind             :string(255)      not null
#  level            :integer          not null
#  name             :string(255)      not null
#  description      :text             default("")
#  population_bonus :decimal(12, 4)   default(0.0)
#  pop_limit_bonus  :decimal(12, 4)   default(0.0)
#  melange_bonus    :decimal(12, 4)   default(0.0)
#  material_bonus   :decimal(12, 4)   default(0.0)
#  solar_bonus      :decimal(12, 4)   default(0.0)
#  exp_bonus        :decimal(12, 4)   default(0.0)
#  population_cost  :decimal(12, 4)   default(0.0)
#  melange_cost     :decimal(12, 4)   default(0.0)
#  material_cost    :decimal(12, 4)   default(0.0)
#  solar_cost       :decimal(12, 4)   default(0.0)
#  exp_cost         :decimal(12, 4)   default(0.0)
#  prerequisity_1   :integer
#  prerequisity_2   :integer
#  prerequisity_3   :integer
#  created_at       :datetime
#  updated_at       :datetime
#

class Building < ActiveRecord::Base
  attr_accessible :name, :level, :kind, :description, :population_bonus, :pop_limit_bonus, :melange_bonus, :material_bonus
  attr_accessible :solar_bonus, :exp_bonus, :population_cost, :melange_cost, :material_cost
  attr_accessible :solar_cost, :exp_cost, :prerequisity_1, :prerequisity_2, :prerequisity_3, :upg_mat_cost, :upg_mel_cost, :upg_sol_cost, :max_upg_lvl, :upg_profit

  has_many :fields, :through => :estates
  has_many :estates

  def naklady_stavba_solary
    self.sum_bonus * self.solar_cost * Constant.ksv
  end

  def naklady_stavba_material
    self.sum_bonus * self.material_cost * Constant.kmav
  end

  def naklady_stavba_populace
    self.sum_bonus * self.population_cost * Constant.kpv
  end

  def naklady_stavba_melange
    self.sum_bonus * self.melange_cost * Constant.kpv
  end

  def naklady_upgrade_stavba_melange
	  self.upg_mel_cost * Constant.naklady_upgrade_stavba_melange
  end

  def naklady_upgrade_stavba_material
	  self.upg_mat_cost * Constant.naklady_upgrade_stavba_material
  end

  def naklady_upgrade_stavba_solary
	  self.upg_sol_cost * Constant.naklady_upgrade_stavba_solary
  end

  def sum_bonus
    self.population_bonus + self.melange_bonus + self.material_bonus + self.solar_bonus + self.exp_bonus + 1
  end

  def vynos_population
    self.population_bonus * Constant.kvynosp * Constant.kpp
  end

  def vynos_solar
    self.solar_bonus * Constant.kvynoss * Constant.ksp
  end

  def vynos_material
    self.material_bonus * Constant.kvynosma * Constant.kmap
  end

  def vynos_exp
    self.exp_bonus * Constant.kvynose * Constant.kep
  end

  def vynos_melange
    self.melange_bonus * Constant.kvynosme * Constant.kmep
  end

  def vynos_parts
    Constant.kvynospar * Constant.kpap
  end

  def nutna_pop
    self.population_cost * Constant.kpv
  end

	def can_be_upgraded(field)
		self.melange_bonus && self.solar_bonus && self.material_bonus && self.max_upg_lvl
	end

  def max_upgraded(current_upg_lvl)
	  self.max_upg_lvl == current_upg_lvl
  end

  def actual_upgrade(field)
	  if self.estates.where(:field_id => field.id).first
		  if (self.estates.where(:field_id => field.id).first).upgrade_lvl
			  (self.estates.where(:field_id => field.id).first).upgrade_lvl
		  else
			  0
		  end
		else
		  0
	  end

  end
end
