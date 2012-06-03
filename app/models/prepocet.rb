# encoding: utf-8
class Prepocet
  def self.kompletni_prepocet
    puts a = Time.now
    puts "PREPOCET"
    Prepocet.zamkni
    order = Prepocet.vytvor_eody
    Prepocet.zmen_vudce(order)
    Prepocet.zpristupni_planety
    Prepocet.produkce_suroviny(order)
    Prepocet.produkce_melanz(order)
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
      if field.planet == Planet.arrakis
        
      else
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
    end
    puts "suroviny vyprodukovany "
  end
  
  def self.produkce_melanz(order)
    puts "PRODUKUJI MELANZ"
    arrakis = Planet.arrakis
    leno = Field.find_by_planet_id(arrakis)
    vlastnik = User.spravce_arrakis
    if vlastnik
      melange = leno.vynos('melange')
    else
      melange = 0.0
    end
    Imperium.zapis_operaci("Bylo vytezeno #{melange} mg melanze.")
    Prepocet.rozdel_melanz(melange, order)
  end
  
  def self.rozdel_melanz(melange, order)
    puts "ROZDELUJI MELANZ = " << melange.to_s
    #pocet = House.playable.count
    #podil = (melange / pocet).round(2)
    gilde = Prepocet.melanz_gilde(melange)
    Imperium.zapis_operaci("Vesmirne Gilde bylo odeslano #{gilde} mg melanze.")
    melange -= gilde
    odevzdano = 0.0
    for house in House.playable.all do
      rodu = melange * (house.melange_percent / 100.0)
      odevzdano += rodu
      house.zapis_operaci("Obdrzeno #{rodu} mg melanze.")
      house.update_attribute(:melange, house.melange + rodu)
      
      # TODO dodelat update vsem userum rodu
      #for eod in user.eods.where(:date => Date.today, :field_id => nil, :order => order).all do
      #  eod.update_attribute(:melange_income, podil)
      #end
    end
    imperiu = melange - odevzdano
    Imperium.zapis_operaci("Do imperialnich skladu bylo odeslano #{imperiu} mg melanze.")
    imperium = House.imperium
    imperium.update_attribute(:melange, imperium.melange + imperiu)
  end
  
  def self.melanz_gilde(melange)
    gilde = melange * (Constant.gilda_melanz_procenta / 100.0)
    if gilde < Constant.gilda_melanz_pevna
      return Constant.gilda_melanz_pevna
    else
      return gilde
    end  
  end

  def self.zpristupni_planety
    puts "Zpristupnuji planety"
    dostupno = Constant.planeta_dostupna_po.days.ago.to_date
    for planeta in Planet.objevene do
      if planeta.discovered_at < dostupno
        planeta.update_attribute(:available_to_all, true)
        Imperium.zapis_operaci("Zpristupnena planeta #{planeta.name} v systemu #{planeta.system_name} (#{planeta.system.id}).")
      end
    end
  end

  def self.zmen_vudce(order)
    houses = House.where('name NOT IN (?)', 'Renegáti, Impérium').includes(:users, :votes)
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
        house.zapis_operaci("Zvolen novy vudce #{n_vudce}.") unless n_vudce == 'nikdo'
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
