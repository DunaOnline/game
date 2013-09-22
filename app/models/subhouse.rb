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
  attr_accessible :name, :house_id, :solar, :melange, :material, :exp

  has_many :users
  belongs_to :house

	def obsazenost_mr
		flag = true
		Subhouse.by_house(self.house_id).all.each do |subhouse|
			if subhouse.users.count > Constant.max_u_mr / 3
			flag = true
			else
			flag =	false
			end
		end
		flag
	end

  def prirad_mr(user)
	  user.update_attribute(:subhouse_id,self.id)
  end

  def pocet_userov
	  self.users.count
  end

  def move_to_house(suroviny,house)
	  msg = ""
	 presun = false
	 suroviny.each do |sur|
		  if sur > 0
			  presun = true
		  end
	 end
	 if presun
		  h_solar = suroviny[0]
		  h_melange = suroviny[1]
		  h_exp = suroviny[2]
		  h_material = suroviny[3]
		  h_parts = suroviny[4]
		  sprava, flag = self.check_availability(h_solar,h_material,h_melange,h_exp,h_parts)
		  if flag == true
			  house = House.find(house)
			  house.update_attributes(:solar => house.solar + h_solar, :material => house.material + h_material, :melange => house.melange + h_melange, :exp => house.exp + h_exp, :parts => house.parts + h_parts)
			  self.update_attributes(:solar => self.solar - h_solar, :material => self.material - h_material, :melange => self.melange - h_melange, :exp => self.exp - h_exp, :parts => self.parts - h_parts)
			  msg += "Posláno narodu #{house.name} #{h_solar} solaru, #{h_material} kg, #{h_melange} mg, #{h_exp} exp, #{h_parts} dilu od malorodu #{self.name}"
			  self.house.zapis_operaci(msg)
		  else
			  msg += sprava
		  end
	 end
	 return msg, flag
  end

  def move_to_mr(suroviny,mr)
	 msg = ""
	 presun = false
	 suroviny.each do |n_sur|
		  if n_sur > 0
			  presun = true
		  end
	 end
	 if presun
		  mr_solar = suroviny[0]
		  mr_melange = suroviny[1]
		  mr_exp = suroviny[2]
		  mr_material = suroviny[3]
		  mr_parts = suroviny[4]
		  sprava, flag = self.check_availability(mr_solar,mr_material,mr_melange,mr_exp,mr_parts)
		  if flag == true
			  mr = Subhouse.find(mr)
			  mr.update_attributes(:solar => mr.solar + mr_solar, :melange => mr.melange + mr_melange, :exp => mr.exp + mr_exp,:material => mr.material + mr_material, :parts => mr.parts + mr_parts)
			  self.update_attributes(:solar => self.solar - mr_solar, :material => self.material - mr_material, :melange => self.melange - mr_melange, :exp => self.exp - mr_exp, :parts => self.parts - mr_parts)
			  msg ="Posláno malorodu #{mr.name} #{mr_solar} solaru, #{mr_material} kg, #{mr_melange} mg, #{mr_exp} exp, #{mr_parts} dilu od malorodu #{self.name}"
			  self.house.zapis_operaci(msg)
		  else
			  msg += sprava
		  end
	 end
	 return msg, flag
  end

  def move_to_user(suroviny,user)
	 msg = ""
	 presun = false
	 suroviny.each do |n_sur|
		  if n_sur > 0
			  presun = true
		  end
	 end
	 if presun
		  u_solar = suroviny[0]
		  u_melange = suroviny[1]
		  u_exp = suroviny[2]
		  u_material = suroviny[3]
		  u_parts = suroviny[4]
		  sprava, flag = self.check_availability(u_solar,u_material,u_melange,u_exp,u_parts)
		  if flag == true
			  user = User.find(user)
			  user.domovske_leno.resource.update_attributes(:material => user.domovske_leno.resource.material + u_material, :parts => user.domovske_leno.resource.parts + u_parts)
			  user.update_attributes(:solar => user.solar + u_solar, :melange => user.melange + u_melange, :exp => user.exp + u_exp)
			  self.update_attributes(:solar => self.solar - u_solar, :material => self.material - u_material, :melange => self.melange - u_melange, :exp => self.exp - u_exp, :parts => self.parts - u_parts)
			  msg += "Posláno hraci #{user.nick} #{u_solar} solaru, #{u_material} kg, #{u_melange} mg, #{u_exp} exp, #{u_parts} dilu od malorodu #{self.name}"
			  self.house.zapis_operaci(msg)
		  else
			  msg += sprava
		  end
	 end
	 return msg, flag
  end



  def posli_mr_suroviny(h,u,mr,narod,user,malorod)

	  msg = ""
	  sprava, flag = self.move_to_house(h,narod)
	  sprava1, flag1 = self.move_to_user(u,user)
	  sprava2, flag2 = self.move_to_mr(mr,malorod)
	  msg += sprava if sprava
	  msg += sprava1 if sprava1
	  msg += sprava2 if sprava2

	  return msg, flag || flag1 || flag2
  end

  def check_availability(sol,mat,mel,exp,par)
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

  def poradi_hlasu(typ, pocet = 5)
	  hlasy = secti_hlasy(typ, pocet)
	  poradi = []
	  hlasy.each do |key, val|
		  poradi << [User.find(key), val]
	  end
	  return poradi
  end

  def secti_hlasy(typ, pocet)
	  self.house.votes.where(:typ => typ).group(:elective).limit(pocet).order('count_id desc, created_at').count('id')
  end

  scope :without_subhouse, lambda{|subhouse| subhouse ? {:conditions => ["id != ?", subhouse.id]} : {} }
  scope :by_house, lambda{ |house| where(house_id: house) unless house.nil? }
end
