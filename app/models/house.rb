# encoding: utf-8
# == Schema Information
#
# Table name: houses
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  leader          :string(255)
#  solar           :decimal(12, 4)   default(0.0)
#  melange         :decimal(12, 4)   default(0.0)
#  material        :decimal(12, 4)   default(0.0)
#  exp             :decimal(12, 4)   default(0.0)
#  playable        :boolean          default(TRUE)
#  melange_percent :decimal(12, 4)   default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  influence       :decimal(, )
#

class House < ActiveRecord::Base
  attr_accessible :name, :leader, :solar, :melange, :material, :exp, :playable, :melange_percent, :parts
  attr_accessible :influence, :pocet_vyhosteni

  has_many :researches
  has_many :users
  has_many :fields, :through => :users
  has_many :planets
  has_many :votes
  has_many :operations
  has_many :syselaads
  has_many :subhouses
  has_many :markets
  has_many :productions

  def poradi_hlasu(typ, pocet = 5)
    hlasy = secti_hlasy(typ, pocet)
    poradi = []
    hlasy.each do |key, val|
      poradi << [User.find(key), val]
    end
    return poradi
  end

  def secti_hlasy(typ, pocet)
    self.votes.where(:typ => typ).group(:elective).limit(pocet).order('count_id desc, created_at').count('id')
  end

  def kdo_je_vitez(typ)
    vitez = secti_hlasy(typ, 1)
    vitez.each_key { |key| return User.find(key) }
  end

  def vudce
    self.users.where(:leader => true).first
  end

  def mentate
    self.users.where(:mentat => true).order(:nick).all
  end

  def army_mentate
    self.users.where(:army_mentat => true).order(:nick).all
  end

  def diplomate
    self.users.where(:diplomat => true).order(:nick).all
  end

  def generalove
    self.users.where(:general => true).order(:nick).all
  end

  def poslanci
    self.users.where(:landsraad => true).order(:nick).all
  end

  def vyskumane_narodni_tech(bonus_type)
    technologie = Technology.where(:bonus_type => bonus_type).first
    vyskumane_tech = self.researches.where(:technology_id => technologie.id).first if technologie
    if vyskumane_tech
      (vyskumane_tech.lvl * technologie.house_bonus) + 1
    else
      1
    end
  end

  def celkova_populace
    pop = 0.0
    for usr in self.users do
      for field in usr.fields do
        pop += field.resource.population
      end
    end
    pop
  end

  def pocet_planet
    self.planets.count
  end

  def volne_planety
	  if Discoverable.kolonizovatelna.all != []
	    true
	  else
		  false
	  end
  end

  def kolonizuj_planetu
    disc = Discoverable.kolonizovatelna.order("RANDOM()").first
    typ = disc.planet_type_id
    typ += (rand(5) - 2)
    typ = 1 if typ < 1
    typ = 8 if typ > 8
    planet = Planet.new(
        :name => disc.name,
        :system_name => disc.system_name,
        :position => disc.position,
        :planet_type_id => typ,
        :house_id => self.id,
        :available_to_all => false,
        :discovered_at => Date.today)
    disc.update_attribute(:discovered, true)
    self.zapis_operaci("Kolonizovana planeta #{planet.name} v systemu #{planet.system_name} (#{planet.system.id}).")
    planet
  end

  def move_to_house(suroviny, house, posiela)
    msg = ""
    presun = false

	    suroviny.each do |sur|
	      if sur > 0
	        presun = true
	      end
	    end
	    if presun  && house != ""
	      h_solar = suroviny[0]
	      h_melange = suroviny[1]
	      h_exp = suroviny[2]
	      h_material = suroviny[3]
	      h_parts = suroviny[4]
	      sprava, flag = self.check_availability(h_solar, h_material, h_melange, h_exp, h_parts)
	      if flag == true
	        house = House.find(house)
	        house.update_attributes(:solar => house.solar + h_solar, :material => house.material + h_material, :melange => house.melange + h_melange, :exp => house.exp + h_exp, :parts => house.parts + h_parts)
	        self.update_attributes(:solar => self.solar - h_solar, :material => self.material - h_material, :melange => self.melange - h_melange, :exp => self.exp - h_exp, :parts => self.parts - h_parts)
	        msg += "Posláno narodu #{house.name} #{h_solar} solaru, #{h_material} kg, #{h_melange} mg, #{h_exp} exp, #{h_parts} dilu od naroda #{self.name}. Poslal #{posiela.nick}. "
	        self.zapis_operaci(msg)
		      house.zapis_operaci(msg)
	      else
	        msg += sprava
	      end
	    else
		    msg = "Nezadali jste narod." if presun
	    end
	  return msg, flag
  end

  def move_to_mr(suroviny, mr, posiela)
    msg = ""
    presun = false

	    suroviny.each do |n_sur|
	      if n_sur > 0
	        presun = true
	      end
	    end
	    if presun  && mr != ""
	      mr_solar = suroviny[0]
	      mr_melange = suroviny[1]
	      mr_exp = suroviny[2]
	      mr_material = suroviny[3]
	      mr_parts = suroviny[4]
	      sprava, flag = self.check_availability(mr_solar, mr_material, mr_melange, mr_exp, mr_parts)
	      if flag == true
	        mr = Subhouse.find(mr)
	        mr.update_attributes(:solar => mr.solar + mr_solar, :melange => mr.melange + mr_melange, :exp => mr.exp + mr_exp, :material => mr.material + mr_material, :parts => mr.parts + mr_parts)
	        self.update_attributes(:solar => self.solar - mr_solar, :material => self.material - mr_material, :melange => self.melange - mr_melange, :exp => self.exp - mr_exp, :parts => self.parts - mr_parts)
	        msg ="Posláno malorodu #{mr.name} #{mr_solar} solaru, #{mr_material} kg, #{mr_melange} mg, #{mr_exp} exp, #{mr_parts} dilu od naroda #{self.name}. Poslal #{posiela.nick}"
	        self.zapis_operaci(msg)
		      mr.zapis_operaci(msg)
	      else
	        msg += sprava
	      end
	    else
		    msg = "Nezadali jste malorod." if presun
	    end
    return msg, flag
  end

  def move_to_user(suroviny, user, posiela)
    msg = ""
    presun = false

	    suroviny.each do |n_sur|
	      if n_sur > 0
	        presun = true
	      end
	    end
	    if presun && user != ""
	      u_solar = suroviny[0]
	      u_melange = suroviny[1]
	      u_exp = suroviny[2]
	      u_material = suroviny[3]
	      u_parts = suroviny[4]
	      sprava, flag = self.check_availability(u_solar, u_material, u_melange, u_exp, u_parts)
	      if flag == true
	        user = User.find(user)
	        user.domovske_leno.resource.update_attributes(:material => user.domovske_leno.resource.material + u_material, :parts => user.domovske_leno.resource.parts + u_parts)
	        user.update_attributes(:solar => user.solar + u_solar, :melange => user.melange + u_melange, :exp => user.exp + u_exp)
	        self.update_attributes(:solar => self.solar - u_solar, :material => self.material - u_material, :melange => self.melange - u_melange, :exp => self.exp - u_exp, :parts => self.parts - u_parts)
	        msg +="Posláno hraci #{user.nick} #{u_solar} solaru, #{u_material} kg, #{u_melange} mg, #{u_exp} exp, #{u_parts} dilu od naroda #{self.name}. Poslal #{posiela.nick}"
	        self.zapis_operaci(msg)
		      user.zapis_operaci(msg)
	      else
	        msg += sprava
	      end
	    else
		    msg = "Nezdali jste hrace." if presun
	    end
    return msg, flag
  end


  def posli_rodove_suroviny(h, u, mr, narod, user, malorod, posiela)

    msg = ""
    sprava, flag = self.move_to_house(h, narod, posiela)
    sprava1, flag1 = self.move_to_user(u, user, posiela)
    sprava2, flag2 = self.move_to_mr(mr, malorod, posiela)
    msg += sprava if sprava
    msg += sprava1 if sprava1
    msg += sprava2 if sprava2

    return msg, flag || flag1 || flag2
  end

  def check_availability(sol, mat, mel, exp, par)
    msg = ""
    flag = false
    bsol = self.solar >= sol
    bmat = self.material >= mat
    bmel = self.melange >= mel
    bexp = self.exp >= exp
    bpar = self.parts >= par
    if bsol && bmat && bmel && bexp && bpar
      flag = true
    else
      flag = false
      msg += "Chybi vam "
      msg += "#{sol - self.solar} solaru" unless bsol
      msg += "#{mat - self.material} materialu" unless bmat
      msg += "#{mel - self.melange} materialu" unless bmel
      msg += "#{exp - self.exp} exp" unless bexp
      msg += "#{par - self.parts} dilu" unless bpar
    end
    return msg, flag
  end


  def eod_zapis_vudce(order, vudce)
    for user in self.users.includes(:eods) do
      for eod in user.eods.where(:date => Date.today, :leader => nil, :order => order).all do
        eod.update_attribute(:leader, vudce.id)
      end
    end
  end

  def self.imperium
    @imperium ||= House.find_by_name('Impérium')
  end

  def self.renegat
    House.find_by_name('Renegáti')
  end

  def goods_to_buyer(typ, amount)

    case typ
      when "M"
        self.update_attribute(:material, self.material + amount)
      when "V"
        self.update_attribute(:parts, self.parts + amount)
      when "J"
        self.update_attribute(:melange, self.melange + amount)
      when "E"
        self.update_attribute(:exp, self.exp + amount)
      else
        production = self.productions.where(:product_id => typ).first
        if production
          production.update_attribute(:amount, production.amount + amount)
        else

        end
    end
  end

  def kapacita_tovaren
    kapacita = 0
    self.users.each do |user|
      kapacita += user.domovske_leno.kapacita_tovaren
    end
    kapacita / Constant.kapacita_t_house
  end

  def miesto_v_tovarni?(amount)
    self.kapacita_tovaren + amount.to_i <= self.kapacita_tovaren
  end

  def zapis_operaci(content, kind = "N")
    self.operations << Operation.new(:kind => kind, :content => content, :house_id => self.id, :date => Date.today, :time => Time.now)
  end

  def vliv
    self.users.sum(:influence)
  end

  def pomer_vlivu
    celk_vl = House.imperium.influence
    vl = self.influence
    if celk_vl == 0
      0.0
    else
      vl / celk_vl
    end
  end

  def bylo_poslano_trh(market, amount)
    self.zapis_operaci("Bylo poslano na trh zbozi #{market.show_area}, #{amount} ks, za #{market.price * amount} solaru")
  end


  def sell_goods_house(market)
    amount = market.amount
    case market.area
      when "M"
        if amount > self.material
          msg = "Nemate dost #{market.show_area}"
        else
          self.update_attribute(:material, self.material - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "V"
        if amount > self.parts
          msg = "Nemate dost #{market.show_area}"
        else
          self.update_attribute(:parts, self.parts - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "J"
        if amount > self.melange
          msg = "Nemate dost #{market.show_area}"
        else
          self.update_attribute(:melange, self.melange - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "E"
        if amount > self.exp
          msg = "Nemate dost #{market.show_area}"
        else
          self.update_attribute(:exp, self.exp - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      else
        production = self.productions.where(:product_id => market.area).first
        if amount > production.amount
          msg = "Nemate dost #{market.show_area}"
        else
          production.update_attribute(:amount, production.amount - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end

    end
    return flag, msg
  end


  def move_product_house(production, amount)
    flag = false
    msg = ""
    if amount > 0
      if production.amount >= amount
        production.update_attribute(:amount, production.amount - amount)
        kam = self.house.productions.where(:product_id => production.product_id).first
        if kam
          flag = true
          kam.update_attribute(:amount, kam.amount + amount)
        else
          Production.new(
              :house_id => self.house.id,
              :product_id => production.product_id,
              :amount => amount
          ).save
          flag = true
        end
      else
        msg = "Nemozete presunut vyrobky"
      end
    else
      msg = "Musite zadat pocet vyrobkov na presun"
    end
    return msg, flag
  end


  def pocet_poslancu
    vliv_na_poslance = House.imperium.influence / Constant.pocet_senatoru

    poslancu = (self.influence / vliv_na_poslance).floor

    #pomer = self.pomer_vlivu
    #poslancu = Landsraad.pocet_poslancu * pomer
    #zaokrouhlene = poslancu.round(0)
    #if poslancu < zaokrouhlene
    #  zaokrouhlene -= 1
    #else
    #  zaokrouhlene += 1
    #end

    return poslancu
  end

  def self.registration
    min = User.group(:house_id).count.sort {|b,a| b[1] <=> a[1]}[0][1]
    pole = []
    House.playable.all.each do |h|
      if h.users.count < min + Constant.rozdiel_u_reg
        pole << [h.name, h.id]
      end
    end
    if pole == []
      House.playable.all.collect { |p| [p.name, p.id] }
    else
      pole
    end

  end


  def for_sale
    na_prodej = []
    vyrobky = self.productions.where("amount > ?", 0)
    vyrobky.each do |vyrobok|
      nazov = Product.find(vyrobok.product_id).title
      na_prodej << [nazov + " " + vyrobok.amount.to_s + "ks", vyrobok.product_id]

    end
    na_prodej << ['Materiál', 'M'] if self.material > 0
    na_prodej << ['Melanž', 'J'] if self.melange > 0
    na_prodej << ['Expy', 'E'] if self.exp > 0
    na_prodej << ['Vyrobky', 'V'] if self.parts > 0
    return na_prodej
  end

  scope :without_house, lambda { |house| house ? {:conditions => ["id != ?", house.id]} : {} }
  scope :playable, where(:playable => true)
end
