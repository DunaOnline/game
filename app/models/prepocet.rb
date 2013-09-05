# encoding: utf-8
class Prepocet
  def self.kompletni_prepocet
    ActiveRecord::Base.transaction do
      puts a = Time.now
      puts "PREPOCET"
      Prepocet.zamkni
      order = Prepocet.vytvor_eody
      Prepocet.zmen_vudce(order)
      Prepocet.zpristupni_planety
      Prepocet.produkce_suroviny(order)
      Prepocet.produkce_melanz(order)

      Prepocet.kontrola_zakonu

      if Constant.pristi_volby == Date.today
        Prepocet.zvol_poslance
      end

      if Imperium.konec_volby_imperatora == Date.today
        Prepocet.zvol_imperatora
      end

      Prepocet.prepocti_vliv

      Prepocet.odemkni
      puts b = Time.now
    end
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
      narod = vlastnik.house if vlastnik
      if field.planet == Planet.arrakis

      else
        solar_exp = vlastnik.vyskumane_tech("S")
        solar_house_exp = narod.vyskumane_narodni_tech("S")
        solar = field.vynos('solar') * (solar_exp + solar_house_exp)

        exp_exp = vlastnik.vyskumane_tech("E")
        exp_house_exp = narod.vyskumane_narodni_tech("E")
        exp = field.vynos('exp') * (exp_exp + exp_house_exp)

        material_exp = vlastnik.vyskumane_tech("M")
        material_house_exp = narod.vyskumane_narodni_tech("M")
        material = field.vynos('material') * (material_exp + material_house_exp)
        population = field.vynos('population')

        parts = field.vynos('parts')

        vlastnik.update_attributes(
            :solar => vlastnik.solar + solar,
            :exp => vlastnik.exp + exp
        )
        field.resource.update_attributes(
            :material => field.resource.material + material,
            :population => field.resource.population + population,
            :parts => field.resource.parts + parts
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
    user_tech = vlastnik.vyskumane_tech("J") if vlastnik
    house_tech = vlastnik.house.vyskumane_narodni_tech("J") if vlastnik
    if vlastnik
      melange = leno.vynos('melange') * (user_tech + house_tech)
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
          old_vudce.zapis_operaci("Byl jsem sesazen z postu vudce.")
          unless house.poradi_hlasu('poslanec', house.pocet_poslancu).include?(old_vudce)
            old_vudce.update_attribute(:landsraad, true)
            old_vudce.zapis_operaci("Nadale nemam pristup do Landsraadu.")
          end
          o_vudce = old_vudce.nick
        end
        unless new_vudce.blank?
          new_vudce.update_attribute(:leader, true)
          new_vudce.zapis_operaci("Byl jsem zvolen novym vudcem.")
          new_vudce.update_attribute(:landsraad, true)
          new_vudce.zapis_operaci("Mam pristup do Landsraadu.")
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

  #######################################

  def self.prepocti_vliv
    for h in House.playable do
      for u in h.users do
        vliv_hrace = u.vliv.round(2)
        u.update_attribute(:influence, vliv_hrace)
        u.zapis_operaci("Muj vliv je nyni: #{vliv_hrace}")
      end
      vliv_rodu = h.vliv
      h.update_attribute(:influence, vliv_rodu)
      h.zapis_operaci("Vliv naroda je nyni: #{vliv_rodu}")
    end
    celkovy_vliv = House.playable.sum(:influence).round(2)
    imp = House.imperium
    imp.update_attribute(:influence, celkovy_vliv)
    Imperium.zapis_operaci("Celkový vliv Impéria nyní činí #{celkovy_vliv}.")
  end

  def self.zvol_poslance
    houses = House.playable
    for h in houses do
      pocet_poslancu = h.pocet_poslancu
      for u in h.poslanci do
        unless u.leader?
          u.update_attribute(:landsraad, false)
          u.zapis_operaci("Jiz nejsem poslancem.")
        end
      end
      for u in h.poradi_hlasu('poslanec', pocet_poslancu) do
        u[0].update_attribute(:landsraad, true)
        u[0].zapis_operaci("Nyni jsem poslancem.")
      end
    end
    Global.prepni('pristi_volby', 2, 4.weeks.from_now)
  end

  def self.kontrola_zakonu
    Prepocet.ukonci_hlasovani
    Prepocet.zarad_zakony
  end

  def self.ukonci_hlasovani
    puts "Ukoncuji hlasovani"
    for law in Law.projednavane do
      if law.submitted.to_date == 3.days.ago.to_date
        law.vyhodnot_zakon
      end
    end
  end

  def self.zarad_zakony
    until Law.projednavane.count == 3 || Law.zarazene.count == 0
      Law.zarazene.order(:position).first.update_attributes(:state => Law::STATE[1], :enacted => Date.today)
    end
  end

  def self.zvol_imperatora
    old_imp = User.imperator
    old_reg = User.regenti

    if old_imp
      old_imp.update_attribute(:emperor, false)
      old_imp.zapis_operaci('Jiz dale nejsem Imperatorem.')
    end
    if old_reg
      for u in old_reg do
        u.update_attribute(:regent, false)
        u.zapis_operaci('Jiz dale nejsem Regentem.')
      end
    end

    imperium = House.imperium
    new_imp = imperium.poradi_hlasu('imperator', 3)
    pocet_hlasujicich = imperium.votes.where(:typ => 'imperator').count
    if new_imp[0][1] > pocet_hlasujicich * 0.6
      new_imp[0][0].update_attribute(:emperor, true)
      new_imp[0][0].zapis_operaci('Byl jsem zvolen Imperatorem.')
    else
      for u in new_imp do
        u[0].update_attribute(:regent, true)
        u[0].zapis_operaci("Byl jsem zvolen Regentem.")
      end
    end

    if new_imp
      Global.prepni('konec_volby_imperatora', 2, 2.week.from_now)
      Global.prepni('volba_imperatora', 1, false)
    end
  end

end
