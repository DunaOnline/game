# encoding: utf-8
class Prepocet
  def self.kompletni_prepocet
    puts a = Time.now
    Prepocet.zamkni
    order = Prepocet.vytvor_eody
    Prepocet.zmen_vudce(order)
    Prepocet.zpristupni_planety
    Prepocet.produkce_suroviny(order)
    Prepocet.odemkni
    puts b = Time.now
  end
  
  def self.vytvor_eody
    order = User.find(1).eods.where(:date => Date.today).maximum(:order)
    if order
      order += 1
    else
      order = 1
    end
    for user in User.all do
      Eod.new(
        :user_id => user.id,
        :date => Date.today,
        :time => Time.now,
        :order => order
      ).save
    end
    puts "Eody vyvtoreny"
    return order
  end

  def self.produkce_suroviny(order)
    for field in Field.includes(:user, :buildings, :resource).all do
      vlastnik = field.user
      
      solar = field.vynos('solar')
      exp = field.vynos('exp')
      material = field.vynos('material')
      population = field.vynos('population')
      
      vlastnik.update_attributes(
        :solar => vlastnik.solar + solar,
        :exp => vlastnik.exp + exp,
      )
      field.resource.update_attributes(
        :material => field.resource.material + material,
        :population => field.resource.population + population
      )
      Eod.new(
        :user_id => vlastnik.id,
        :field_id => field.id,
        :date => Date.today, 
        :time => Time.now, 
        :order => order,
        :solar_income => solar, 
        :exp_income => exp, 
        :material_income => material, 
        :population_income => population
      ).save
    end
    puts "suroviny vyprodukovany "
  end

  def self.zpristupni_planety
    puts "Zpristupnuji planety"
    for planeta in Planet.objevene do
      if planeta.discovered_at < Constant.planeta_dostupna_po.days.ago.to_date
        planeta.update_attribut(:available_for_all, true)
        puts "Zpristupnena planeta #{planeta.name}/#{planeta.systema_name}"
      end
    end
  end

  def self.zmen_vudce(order)
    houses = House.where('name NOT IN (?)', 'Renegáti').includes(:users, :votes)
    for house in houses do
      puts "Delam #{house.name}"
      old_vudce = house.users.where(:leader => true).first
      new_vudce = house.kdo_je_vitez('leader')
      if old_vudce == new_vudce
        
      else
        o_vudce = 'nikdo'
        n_vudce = 'nikdo'
        if old_vudce
          old_vudce.update_attribute(:leader, false)
          o_vudce = old_vudce.nick
        end
        unless new_vudce.blank?
          new_vudce.update_attribute(:leader, true)
          n_vudce = new_vudce.nick
        end
        puts "Menim vudce #{o_vudce} na #{n_vudce}"
      end
      house.eod_zapis_vudce(order, new_vudce)
    end
    puts "vudcove zmeneni"
  end

  def self.odemkni
    Aplikace.odemkni_hru
    puts "hra odemcena"
  end

  def self.zamkni
    Aplikace.zamkni_hru
    puts "hra uzamcena"
  end
end
