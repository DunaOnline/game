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

  def naklady_stavba_melange
	  self.sum_bonus * self.melange_cost * Constant.kpv
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

  def postav_availability_check(field,pocet_budov)

	  tech = field.user.vyskumane_tech("L")

	  bonus = (2 - tech).to_f

	  cena_sol = self.naklady_stavba_solary * bonus
	  cena_mat = self.naklady_stavba_material * bonus
	  cena_mel = self.naklady_stavba_melange * bonus
	  mat_na_poli = field.resource.material
	  melange_user = field.user.melange
	  postaveno = false
	  message = ""

	  solary = cena_sol * pocet_budov < field.user.solar
	  material = cena_mat * pocet_budov < mat_na_poli
	  melange = cena_mel * pocet_budov < melange_user
	  miesto = pocet_budov < field.volne_misto
	  if miesto
		  if pocet_budov > 0
			  if solary && material && melange
				  field.user.update_attribute(:solar, field.user.solar - (cena_sol * pocet_budov))
				  field.user.update_attribute(:melange, field.user.melange - (cena_mel * pocet_budov))
				  field.resource.update_attribute(:material, mat_na_poli - (cena_mat * pocet_budov))
				  field.postav(self, pocet_budov)
				  postaveno = true
				  message += "Bylo postaveno #{pocet_budov} budov"
			  else

				  message += "Chybi vam "
				  message += "#{cena_sol * pocet_budov} sol, " if solary
				  message += "#{cena_mat * pocet_budov} kg," if material
				  message += "#{cena_mel * pocet_budov} mg" if melange
				  message += "."
				end
			else
				if pocet_budov.abs > field.postaveno(self)
					message += "Tolik budov nelze prodat."

				else
				  field.user.update_attribute(:solar, field.user.solar + ((cena_sol / 2) * pocet_budov.abs))
				  field.user.update_attribute(:melange, field.user.melange + ((cena_mel / 2) * pocet_budov.abs))
				  field.resource.update_attribute(:material, mat_na_poli + ((cena_mat / 2) * pocet_budov.abs))
				  field.postav(self, pocet_budov)

				  message += "Bylo prodano #{pocet_budov.abs} budov dostali jste #{(cena_sol / 2) * pocet_budov.abs} solaru a #{(cena_mat / 2) * pocet_budov.abs} kg materialu "
					message += "a #{(cena_mel / 2) * pocet_budov.abs} mg melanze." if cena_mel > 0
					postaveno = true
			  end
			end
	  else
		  message += "Nemate tolik mista na stavbu"
	  end
	  return message, postaveno
	end



end
