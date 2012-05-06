class Building < ActiveRecord::Base
  attr_accessible :name, :level, :kind, :description, :population_bonus, :pop_limit_bonus, :melange_bonus, :material_bonus
  attr_accessible :solar_bonus, :exp_bonus, :population_cost, :melange_cost, :material_cost
  attr_accessible :solar_cost, :exp_cost, :prerequisity_1, :prerequisity_2, :prerequisity_3
  
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
  
  def sum_bonus
    self.population_bonus + self.melange_bonus + self.material_bonus + self.solar_bonus + self.exp_bonus
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
  
  def nutna_pop
    self.population_cost * Constant.kpv
  end
  
end
