# encoding: utf-8
# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  planet_id  :integer          not null
#  name       :string(255)      not null
#  pos_x      :decimal(, )      default(0.0)
#  pos_y      :decimal(, )      default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Field < ActiveRecord::Base
  attr_accessible :user_id, :planet_id, :name, :pos_x, :pos_y

  belongs_to :user
  has_one :house, :through => :user
  belongs_to :planet
  has_one :resource
  has_many :estates
  has_many :buildings, :through => :estates

  has_many :influence
  has_many :effect, :through => :influence

  after_save :vytvor_resource

  def vytvor_resource
    # nejak mi nefunguje after_create tak jak ma
    unless self.resource
	    pop = Constant.vytvor_resource_pop
	    mat = Constant.vytvor_resource_mat
      Resource.new(:user_id => self.user_id, :field_id => self.id, :population => pop, :material => mat, :parts => 0).save
    end
  end

  def souradnice
    self.pos_x.to_i.to_s + "." + self.pos_y.to_i.to_s
  end

  def oznaceni
    self.planet.id.to_s + "." + self.id.to_s + "." + self.souradnice
  end

  def drzitel(user)
    if user.admin?
      true
    else
      self.user == user
    end
  end

  def vynos(ceho)
    vynos = 0.0
    case ceho
      when 'solar'
        kind = 'S'
      when 'material'
        kind = 'M'
      when 'exp'
        kind = 'E'
      when 'population'
        kind = 'L'
      when 'melange'
        kind = 'J'
      when 'parts'
        kind = 'V'
    end
    pop = self.resource.population
    for building in self.buildings.where('kind LIKE ?', '%'+kind+'%') do
      pocet = self.estates.where(:building_id => building).first.number
      attr = 'vynos_' + ceho
      if pop > building.nutna_pop
        vynos += building.send(attr) * pocet
      else
        vynos += building.send(attr) * pocet * Constant.vynos_bez_pop
      end
    end
    vynos
  end

  def postaveno(building)
    estate = self.estates.where(:building_id => building).first
    if estate
      estate.number
    else
      0
    end
  end

  def zastavba
    max = self.max_budov
    aktualne = self.aktualne_zastaveno
    aktualne.to_s + "/" + max.to_s
  end

  def max_budov
    Constant.budov_na_leno.to_i
  end

  def aktualne_zastaveno
    self.estates.sum(:number)
  end

  def volne_misto
    self.max_budov - self.aktualne_zastaveno
  end

  def postav(budova, pocet)
    estate = self.estates.where(:building_id => budova).first
    if estate
      estate.update_attribute(:number, estate.number + pocet)
    else
      Estate.new(
          :field_id => self.id,
          :building_id => budova.id,
          :number => pocet
      ).save
    end
  end

  def upgrade_availability_check(budova, pocet_vylepseni)
	  flag = false
	  msg = "Nemate dostatek surovin chybi vam : "
	  cena_sol = budova.upg_sol_cost
	  cena_mat = budova.upg_mat_cost
	  cena_mel = budova.upg_mel_cost
	  mat_na_poli = self.resource.material
	  estate = budova.estates.where(:field_id => self.id).first
	  if estate
		  estate_upg_lvl = estate.upgrade_lvl ? estate.upgrade_lvl : 0
		  max_lvl = budova.max_upg_lvl
		  if estate_upg_lvl != max_lvl
			  lvl = max_lvl > estate_upg_lvl
				  solary = cena_sol * pocet_vylepseni <= self.user.solar
				  material = cena_mat * pocet_vylepseni <= mat_na_poli
				  melange = cena_mel * pocet_vylepseni <= self.user.melange

				if solary && material && melange && lvl

					  if !estate.upgrade_lvl
						  pocet_vylepseni = ((pocet_vylepseni > max_lvl) ? max_lvl : pocet_vylepseni)
						  estate.update_attribute(:upgrade_lvl,pocet_vylepseni)
					  else
						  pocet_vylepseni = (((pocet_vylepseni + estate.upgrade_lvl) > max_lvl )? max_lvl - estate.upgrade_lvl : pocet_vylepseni)
						  estate.update_attribute(:upgrade_lvl,estate.upgrade_lvl + pocet_vylepseni)
					  end
					  self.user.update_attributes(:melange => self.user.melange - cena_mel * pocet_vylepseni, :solar => self.user.solar - cena_sol * pocet_vylepseni)
					  self.resource.update_attribute(:material,mat_na_poli - cena_mat * pocet_vylepseni)
					  msg = "Budova byla vylepsena #{pocet_vylepseni} krat, zaplatili jsme #{cena_sol * pocet_vylepseni} sol, #{cena_mat * pocet_vylepseni} kg a #{cena_mel * pocet_vylepseni} mg."
					  self.user.zapis_operaci(msg)
					  flag = true
				else
					  msg += "#{(cena_sol * pocet_vylepseni) - self.user.solar} sol " if !solary
					  msg += "#{(cena_mat * pocet_vylepseni) - self.user.solar} kg " if !material
					  msg += "#{(cena_mel * pocet_vylepseni) - self.user.solar} mg " if !melange
					  msg += "."
				end
		  else
			  flag = false
			  msg = "Vylepseni je na max levelu"
			end

	  else
		  msg = "Nemate postavenu budovu tohoto typu"
		end
	  return flag, msg
  end

  def upgrade_sell_availability_check(budova, pocet_vylepseni)
	  flag = false
	  msg = ""
	  cena_sol = budova.upg_sol_cost / 2
	  cena_mat = budova.upg_mat_cost / 2
	  cena_mel = budova.upg_mel_cost / 2
	  mat_na_poli = self.resource.material
	  estate = budova.estates.where(:field_id => self.id).first

	  lvl = estate.upgrade_lvl ? estate.upgrade_lvl : 0 > 0
	  if lvl
		  upgrade = estate.upgrade_lvl
		  if upgrade > pocet_vylepseni
			  estate.update_attribute(:upgrade_lvl, upgrade - pocet_vylepseni)
			  self.user.update_attributes(:melange => self.user.melange + cena_mel * pocet_vylepseni, :solar => self.user.solar + cena_sol * pocet_vylepseni)
			  self.resource.update_attribute(:material,mat_na_poli + cena_mat * pocet_vylepseni)
			  msg = "Bylo prodano #{pocet_vylepseni} vylepseni, ziskali jsme #{cena_sol * pocet_vylepseni} sol, #{cena_mat * pocet_vylepseni} kg a #{cena_mel * pocet_vylepseni} mg."
		    self.user.zapis_operaci(msg)
			  flag = true
		  elsif upgrade == 0
			  flag = false
			  msg = "Nemate zadne vylepseni na prodej"
		  else
			  estate.update_attribute(:upgrade_lvl, 0)
			  self.user.update_attributes(:melange => self.user.melange + cena_mel * upgrade, :solar => self.user.solar + cena_sol * upgrade)
			  self.resource.update_attribute(:material,mat_na_poli + cena_mat * upgrade)
			  msg = "Bylo prodano #{pocet_vylepseni} vylepseni, ziskali jsme #{cena_sol * upgrade} sol, #{cena_mat * upgrade} kg a #{cena_mel * upgrade} mg."
			  self.user.zapis_operaci(msg)
			  flag = true
		  end
	  end

	 return flag, msg
  end

  def postav_availability_check(budova, pocet_budov)

    tech = self.user.tech_bonus("L")
    house_lvl = self.user.house.vyskumane_narodni_tech("L")
    bonus = 2 - (tech * house_lvl)

    cena_sol = budova.naklady_stavba_solary * bonus
    cena_mat = budova.naklady_stavba_material * bonus
    cena_mel = budova.naklady_stavba_melange * bonus
    mat_na_poli = self.resource.material
    melange_user = self.user.melange
    postaveno = false
    message = ""

    solary = cena_sol * pocet_budov <= self.user.solar
    material = cena_mat * pocet_budov <= mat_na_poli
    melange = cena_mel * pocet_budov <= melange_user
    miesto = pocet_budov <= self.volne_misto
    if miesto
      if pocet_budov > 0
        if solary && material && melange
          self.user.update_attribute(:solar, self.user.solar - (cena_sol * pocet_budov))
          self.user.update_attribute(:melange, self.user.melange - (cena_mel * pocet_budov))
          self.resource.update_attribute(:material, mat_na_poli - (cena_mat * pocet_budov))
          self.postav(budova, pocet_budov)
          self.zapis_udalosti(self.user, "Bylo postaveno #{pocet_budov} #{budova.name} na lenu #{self.name} za #{cena_sol * pocet_budov} solaru,
					#{cena_mel * pocet_budov} mg a #{cena_mat * pocet_budov} kg")
          postaveno = true
          message += "Bylo postaveno #{pocet_budov} budov" if pocet_budov > 1
          message += "Byla postavena #{pocet_budov} budova" if pocet_budov == 1
        else
          message += "Chybi vam "
          message += "#{(cena_sol * pocet_budov - self.user.solar).to_f} sol, " unless solary
          message += "#{(cena_mat * pocet_budov - mat_na_poli).to_f} kg," unless material
          message += "#{(cena_mel * pocet_budov - melange_user).to_f} mg" unless melange
          message += "."
        end
      else
        if pocet_budov.abs > self.postaveno(budova)
          message += "Tolik budov nelze prodat."
        else
          self.user.update_attribute(:solar, self.user.solar + ((cena_sol / 2) * pocet_budov.abs))
          self.user.update_attribute(:melange, self.user.melange + ((cena_mel / 2) * pocet_budov.abs))
          self.resource.update_attribute(:material, mat_na_poli + ((cena_mat / 2) * pocet_budov.abs))
          self.postav(budova, pocet_budov)
          self.zapis_udalosti(self.user, "Bylo prodano #{pocet_budov.abs} #{budova.name} na lenu #{self.name}. Ziskali sme #{(cena_sol / 2) * pocet_budov.abs} solaru,
					#{(cena_mel / 2) * pocet_budov.abs} mg a #{(cena_mat / 2) * pocet_budov.abs} kg")

          message += "Bylo prodano #{pocet_budov.abs} budov dostali jste #{(cena_sol / 2) * pocet_budov.abs} solaru a #{(cena_mat / 2) * pocet_budov.abs} kg materialu " if pocet_budov.abs > 1
          message += "Byla prodana #{pocet_budov.abs} budova dostali jste #{(cena_sol / 2) * pocet_budov.abs} solaru a #{(cena_mat / 2) * pocet_budov.abs} kg materialu " if pocet_budov.abs == 1
          message += "a #{(cena_mel / 2) * pocet_budov.abs} mg melanze." if cena_mel > 0
          postaveno = true
        end
      end
    else
      message += "Nemate tolik mista na stavbu"
    end
    return message, postaveno
  end

  def vyuzitie_tovaren
    vyrobky = self.resource.productions
    pocet_vyrobkov = 0
    vyrobky.each do |vyrobok|
      pocet_vyrobkov += vyrobok.amount
    end

    pocet_vyrobkov
    #.to_s + "/" + self.kapacita_tovaren.to_s

  end

  def kapacita_tovaren
    number = 0
    tovarna = Building.where(:kind => "V").first
    kapacita = self.estates.where(:building_id => tovarna.id).first
    number = (kapacita.number * Constant.kapacita_tovaren).to_i if kapacita
    number
  end

  def move_products(co, target, amount)
    vyrobok = Product.find(co)
    source_production = self.resource.productions.where(:product_id => vyrobok.id).first
    target_production = target.resource.productions.where(:product_id => vyrobok.id).first
    if source_production
      unless target_production
        target_production = Production.new(
            :user_id => target.user.id,
            :resource_id => target.resource.id,
            :product_id => vyrobok.id,
            :amount => 0
        )
      end

      case str = source_production.check_availability(amount, target, target_production) && self.user.solar >= Constant.presun_vyrobku * amount
        when true
          source_production.update_attribute(:amount, source_production.amount - amount)
          target_production.update_attribute(:amount, target_production.amount + amount)
          self.zapis_udalosti(self.user, "Bylo presunuto #{amount} ks #{vyrobok.title} z #{self.name} na #{target.name} leno, Za presun zaplaceno #{Constant.presun_vyrobku * amount} solaru")
        else
          message = str

      end
    else
      "Jeste jste nepostavili vyrobky tohoto typu"
    end
  end

  def vyroba_vyrobkov(vyrobky)
    field = self
    zdroje_lena = field.resource
    total_material = 0
    total_melanz = 0
    total_price = 0
    total_parts = 0
    total_pocet = 0
    vyrobeno = false

    vyrobky.each do |vyrobok|
      pocet = vyrobok[0]
      pocet = pocet[0].to_i.abs
      total_pocet += pocet
      coho = Product.where(:title => vyrobok[1]).first

      total_material += coho.material * pocet
      total_melanz += coho.melanz * pocet
      total_price += coho.price * pocet
      total_parts += coho.parts * pocet

    end
    material = zdroje_lena.material >= total_material
    melanz = field.user.melange >= total_melanz
    price = field.user.solar >= total_price
    parts = zdroje_lena.parts >= total_parts
    miesto = field.kapacita_tovaren > field.vyuzitie_tovaren + total_pocet

    oznamenie = ""
    if miesto
	    if material && melanz && price && parts
	      vyrobky.each do |vyrobok|
	        pocet = vyrobok[0]
	        pocet = pocet[0].to_i
	        coho = Product.where(:title => vyrobok[1]).first

	        produkcia = Production.where(:resource_id => zdroje_lena.id, :product_id => coho.id).first
	        if produkcia
	          produkcia.update_attribute(:amount, produkcia.amount + pocet)
	        else
	          Production.new(
	              :user_id => field.user.id,
	              :resource_id => zdroje_lena.id,
	              :product_id => coho.id,
	              :amount => pocet
	          ).save
	        end
	        self.zapis_udalosti(self.user, "Bylo nakoupeno #{pocet} ks #{coho.title} za #{coho.material * pocet} kg, #{coho.melanz * pocet} mg,
					#{coho.price * pocet} solaru a #{coho.parts * pocet} vyrobku")
	      end

	      zdroje_lena.update_attributes(:material => zdroje_lena.material - total_material, :parts => zdroje_lena.parts - total_parts)
	      field.user.update_attributes(:solar => field.user.solar - total_price, :melange => field.user.melange - total_melanz)
	      vyrobeno = true
	    else
	      oznamenie += "Chybi vam "
	      oznamenie += (total_material - zdroje_lena.material).to_s + " kg materialu " unless material
	      oznamenie += (total_melanz - field.user.melange).to_s + " mg melanze " unless melanz
	      oznamenie += (total_parts - zdroje_lena.parts).to_s + " vyrobkov " unless parts
	      oznamenie += (total_price - field.user.solar).to_s + " solaru " unless price
	      oznamenie += "."
	    end
    else
	    oznamenie += "Nemate dostatek mista v tovarni"
    end

    return oznamenie, vyrobeno
  end

  def predaj_produktov(vyrobky)
    field = self

    total_material = 0
    total_melanz = 0
    total_price = 0
    total_parts = 0
    number = 0
    oznamenie = ""

    nemozno_prodat = false

    vyrobky.each do |vyrobok|
      pocet = vyrobok[0]
      pocet = pocet[0].to_i.abs
      coho = Product.where(:title => vyrobok[1]).first
      if coho
        if 0 < coho.vlastnim(field) && coho.vlastnim(field) >= pocet
          total_material += (coho.material * pocet) / 2
          total_melanz += (coho.melanz * pocet) / 2
          total_price += (coho.price * pocet) / 2
          total_parts += (coho.parts * pocet) / 2
          number += pocet

          produkcia = Production.where(:resource_id => field.resource.id, :product_id => coho.id).first
          produkcia.update_attribute(:amount, produkcia.amount - pocet)
          field.resource.update_attributes(:material => field.resource.material + total_material, :parts => field.resource.parts + total_parts)
          field.user.update_attributes(:solar => field.user.solar + total_price, :melange => field.user.melange + total_melanz)
          self.zapis_udalosti(self.user, "Bylo prodano #{pocet} ks #{coho.title} za #{(coho.material * pocet) / 2} kg, #{(coho.melanz * pocet) / 2} mg,
					#{(coho.price * pocet) / 2} solaru a #{(coho.parts * pocet) / 2} vyrobku")
        else
          nemozno_prodat = true
        end
      end


    end
    if nemozno_prodat
      oznamenie += "Tolik vyrobku nemozno prodat"
    else
      oznamenie += "Bylo prodano #{number} vyrobku, prodejem sme ziskali #{total_material} kg materialu, #{total_melanz} mg melanze, #{total_price} solaru a #{total_parts} dilu"
    end

    return oznamenie, nemozno_prodat

  end

  def suroviny(what)
	  case what
		  when 'Population'
			  self.resource.population
		  when 'Material'
			  self.resource.material
		  when 'Parts'
			  self.resource.parts
		  else
			  0
	  end
  end


  def move_resource(to, what, amount, all)

	  amount = all ? self.suroviny(what) : amount
    flag = self.check_availability(what, amount,to) if self.planet == to.planet

    flag = self.check_availability(what, amount, to, "planeta") if self.planet != to.planet
    if flag == "S"

      case what
        when 'Population'
           self.move_population(amount,to)
        when 'Material'
           self.move_material(amount,to)
        when 'Parts'
           self.move_parts(amount,to)
        else
          "Toto nelze poslat"
      end
    elsif flag == "I"
	    "Nemáte dost solaru na presun. "
    elsif flag == "N"
	    "Nemáte dostatecnou kapacitu na prichozim lenu. "
    else
      "Nedostatek surovin na odchozím léně"
    end
  end

  def move_population(amount,to)
	  self.resource.update_attribute(:population, self.resource.population - amount.abs)
	  to.resource.update_attribute(:population, to.resource.population + amount.abs)
	  if self.planet == to.planet
		  self.user.preprava_cost(amount, "leno")
		  self.zapis_udalosti(self.user, "Bylo presunuto #{amount} populacie z #{self.name} na #{to.name} leno, za presun mezi leny jsme zaplatili #{amount * Constant.presun_planeta} solaru")
	  else

		  self.user.preprava_cost(amount, "planeta")
		  self.zapis_udalosti(self.user, "Bylo presunuto #{amount} populacie z #{self.name} na #{to.name} leno, za presun mezi planetami jsme zaplatili #{amount * Constant.presun_planeta} solaru")
	  end
  end

  def move_material(amount,to)
	  self.resource.update_attribute(:material, self.resource.material - amount.abs)
	  to.resource.update_attribute(:material, to.resource.material + amount.abs)
	  if self.planet == to.planet
		  self.user.preprava_cost(amount, "leno")
		  self.zapis_udalosti(self.user, "Bylo presunuto #{amount} materialu z #{self.name} na #{to.name} leno, za presun mezi leny jsme zaplatili #{amount * Constant.presun_planeta} solaru")
	  else
		  self.user.preprava_cost(amount, "planeta")
		  self.zapis_udalosti(self.user, "Bylo presunuto #{amount} materialu z #{self.name} na #{to.name} leno, za presun mezi planetami jsme zaplatili #{amount * Constant.presun_planeta} solaru")
	  end
  end

  def move_parts(amount,to)
	  self.resource.update_attribute(:parts, self.resource.parts - amount.abs)
	  to.resource.update_attribute(:parts, to.resource.parts + amount.abs)
	  if self.planet == to.planet
		  self.user.preprava_cost(amount, "leno")
		  self.zapis_udalosti(self.user, "Bylo presunuto #{amount} vyrobku z #{self.name} na #{to.name} leno, za presun mezi leny jsme zaplatili #{amount * Constant.presun_planeta} solaru")
	  else
		  self.user.preprava_cost(amount, "planeta")
		  self.zapis_udalosti(self.user, "Bylo presunuto #{amount} vyrobku z #{self.name} na #{to.name} leno, za presun mezi planetami jsme zaplatili #{amount * Constant.presun_planeta} solaru")
	  end
  end

  def self.udalosti_lena
    influence = Influence.all
    influence.each do |infl|
      if infl.duration == 0
        infl.destroy
      else
        infl.update_attribute(:duration, infl.duration - 1)
      end
    end
    self.all.each do |field|
      field.udalost
    end
  end

  def udalost
    udalost = 0

    pocet_udalosti = Constant.pocet_udalosti.to_i
    pocet_udalosti.times do
      if udalost == rand(100 / Constant.pravdepodobnost)
        if Effect.count > 0
          roll_effect = rand(Property.count) + 1
          effect = Effect.find(roll_effect)
          Influence.new(
              :field_id => self.id,
              :effect_id => effect.id,
              :duration => effect.duration
          ).save
          if self.planet == Planet.arrakis
            #self.user.zapis_operaci("Mimoriadna udalost #{effect.name}")
          else
            self.user.zapis_operaci("Mimoriadna udalost na lenu #{self.name} : #{effect.name}")
          end
          udalost += 1
        end
      end
    end
  end

  def leno_udalost_bonus(typ)
    enviro_bonus = 1
    if self.influence
      case typ
        when "P"
          self.influence.each do |influence|
            enviro_bonus = influence.effect.population_bonus * influence.effect.population_cost if influence
          end
        when "PL"
          self.influence.each do |influence|
            enviro_bonus = influence.effect.pop_limit_bonus if influence
          end
        when "J"
          self.influence.each do |influence|
            enviro_bonus = influence.effect.melange_bonus * influence.effect.melange_cost if influence
          end
        when "M"
          self.influence.each do |influence|
            enviro_bonus = influence.effect.material_bonus * influence.effect.material_cost if influence
          end
        when "S"
          self.influence.each do |influence|
            enviro_bonus = influence.effect.solar_bonus * influence.effect.solar_cost if influence
          end
        when "E"
          self.influence.each do |influence|
            enviro_bonus = influence.effect.exp_bonus * influence.effect.exp_cost if influence
          end
        else
          enviro_bonus = 1
      end
    end

    enviro_bonus
  end

  def check_availability(what, amount, to, typ="leno")
    poplatok = Constant.presun_leno if typ == "leno"
    poplatok = Constant.presun_planeta if typ == "planeta"
    poplatok = Constant.presun_populace if what == "Population" && typ == "leno"
    poplatok = Constant.presun_populace_planeta if what == "Population" && typ == "planeta"
    if poplatok <= self.user.solar
	    flag = "F"
      case what
	      when 'Population'
		      flag = "S" if self.resource.population >= amount
        when 'Material'
          flag = "S" if self.resource.material >= amount
	      when 'Parts'
		      if self.resource.parts >= amount && self.resource.parts + amount <= to.kapacita_tovaren
            flag = "S"
		      else
			      flag = "N"
		      end
      end
    else
	    flag = "I"
    end
	  flag
  end

  def zapis_udalosti(user, content)
    Operation.new(:kind => "U", :user_id => user.id, :content => content, :date => Date.today, :time => Time.now).save
  end

  scope :vlastnik, lambda { |user| where(:user_id => user.id) }
  scope :without_field, lambda { |field| field ? {:conditions => ["id != ?", field.id]} : {} }

end
