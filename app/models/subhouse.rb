# encoding: utf-8
# == Schema Information
#
# Table name: subhouses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  house_id   :integer
#  solar      :integer
#  melange    :decimal(, )
#  material   :decimal(, )
#  exp        :integer
#  created_at :datetime
#  updated_at :datetime
#

class Subhouse < ActiveRecord::Base
  attr_accessible :name, :house_id, :solar, :melange, :material, :exp, :parts

  has_many :markets
  has_many :productions
  has_many :users
  has_many :operations
  belongs_to :house

  validates_length_of :name, :minimum => 3, :maximum => 20
  #validates_presence_of :name

  def obsazenost_mr
    flag = 0
    Subhouse.by_house(self.house_id).all.each do |subhouse|
      unless subhouse.users.count > Constant.max_u_mr / Constant.perc_mr_obs
        flag += 1
      end
    end
    if flag >= Constant.poc_prazdnych_mr
	    return false
    else
	    return true
    end
  end

  def nastav_generala
	  votes = Hash.new
	  self.users.each do |u|
		  if u.general
		   u.update_attribute(:general,false)
		  end
		  votes[u.id] = u.votes.where(:typ => 'general').count
	  end
	  general = User.find(votes.max_by{|k,v| v}[0])                   #votes.values.max
	  general.update_attribute(:general,true)
  end

  def prirad_mr(user)
    user.update_attribute(:subhouse_id, self.id)
  end

  def pocet_userov
    self.users.count
  end

  def zapis_operaci(content)
    self.operations << Operation.new(:kind => "M", :subhouse_id => self.id, :content => content, :date => Date.today, :time => Time.now)
  end

  def bylo_poslano_trh(market, amount)
    self.zapis_operaci("Bylo poslano na trh zbozi #{market.show_area}, #{amount} ks, za #{market.price * amount} solaru")
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
          Production.new(
              :product_id => typ,
              :amount => amount,
              :subhouse_id => self.id
          ).save
        end
    end
  end

  def sell_goods_subhouse(market)
    flag = false
    msg = ""
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

  def move_to_house(suroviny, house, posiela)
    msg = ""
    presun = false
    suroviny.each do |sur|
      if sur > 0
        presun = true
      end
    end
    if presun && house != ""
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
        msg += "Posláno narodu #{house.name} #{h_solar} solaru, #{h_material} kg, #{h_melange} mg, #{h_exp} exp, #{h_parts} dilu od malorodu #{self.name}. Poslal #{posiela.nick}. "
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
    if presun && mr != ""
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
        msg ="Posláno malorodu #{mr.name} #{mr_solar} solaru, #{mr_material} kg, #{mr_melange} mg, #{mr_exp} exp, #{mr_parts} dilu od malorodu #{self.name}. Poslal #{posiela.nick}. "
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
    if presun  && user != ""
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
        msg += "Posláno hraci #{user.nick} #{u_solar} solaru, #{u_material} kg, #{u_melange} mg, #{u_exp} exp, #{u_parts} dilu od malorodu #{self.name}. Poslal #{posiela.nick}. "
        self.zapis_operaci(msg)
	      user.zapis_operaci(msg)
      else
        msg += sprava
      end
    else
	    msg = "Nezadali jste hrace." if presun
    end
    return msg, flag
  end


  def posli_mr_suroviny(h, u, mr, narod, user, malorod, posiela)

    msg = ""
    sprava, flag = self.move_to_house(h, narod, posiela)
    sprava1, flag1 = self.move_to_user(u, user, posiela)
    sprava2, flag2 = self.move_to_mr(mr, malorod, posiela)
    msg += sprava if sprava
    msg += sprava1 if sprava1
    msg += sprava2 if sprava2

    return msg, flag || flag1 || flag2
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

  def kapacita_tovaren
    kapacita = 0
    self.users.each do |user|
      kapacita += user.domovske_leno.kapacita_tovaren
    end
    kapacita * Constant.kapacita_t_mr
  end

  def vyuzitie_tovaren
    vyrobky = self.productions
    pocet_vyrobkov = 0
    vyrobky.each do |vyrobok|
      pocet_vyrobkov += vyrobok.amount
    end

    pocet_vyrobkov
  end

  def miesto_v_tovarni?(amount)
    self.vyuzitie_tovaren + amount <= self.kapacita_tovaren
  end

  def poradi_hlasu(typ, pocet = 5)
    hlasy = secti_hlasy(typ, pocet)
    poradi = []
    hlasy.each do |key, val|
      poradi << [User.find(key), val] if User.find(key).subhouse == self
    end
    return poradi
  end

  def secti_hlasy(typ, pocet)
	  self.house.votes.where(:typ => typ).group(:elective).limit(pocet).order('count_id desc, created_at').count('id')
  end

  scope :without_subhouse, lambda { |subhouse| subhouse ? {:conditions => ["id != ?", subhouse.id]} : {} }
  scope :by_house, lambda { |house| where(house_id: house) unless house.nil? }
end
