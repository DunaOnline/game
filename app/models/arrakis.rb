# encoding: utf-8
class Arrakis

  def self.planeta
    @duna ||= Planet.find_by_name('Arrakis')
  end

  def self.leno
    @duna_field ||= Arrakis.planeta.fields.first
  end

  def self.zdroje
    Arrakis.leno.resource
  end

  def self.harvester
    @harv ||= Building.where(:name => 'Továrna na koření').first
    Arrakis.leno.estates.where(:building_id => @harv.id).first
  end

  def self.agresivita_fremenu
    Global.vrat('agrese_fremenu', 4)
  end

  def self.zvys_agresi_fremenu
    pocet_harvesteru = Arrakis.harvester.number
    agrese = Arrakis.agresivita_fremenu
    hranice_harvesteru = Global.vrat('hranice_harvesteru', 4)

    nova_agrese = agrese + (Math.exp(pocet_harvesteru/hranice_harvesteru))

    Global.prepni('agrese_fremenu', 4, nova_agrese)
  end

  def self.sniz_agresi_fremenu(o_kolik)
    Global.prepni('agrese_fremenu', 4, Arrakis.agresivita_fremenu - o_kolik)
  end

  def self.kontrola_fremenu
    agr = Arrakis.agresivita_fremenu
    rnd = rand(10000)/100.0+1
    if rnd <= agr
      harv = Arrakis.harvester
      stare_harv = harv.number
      nove_harv = (harv.number * (1-(agr/2)/100)).round
      harv.update_attribute(:number, nove_harv)
      Global.prepni('agrese_fremenu', 4, agr/2)
      Imperium.zapis_operaci("Na Arrakis Fremeni zaútočili na sklizňové operace a zničili #{stare_harv-nove_harv} Továren na koření.")
      Imperium.zapis_operaci("Pravděpodobnost jejich další agrese je #{Arrakis.agresivita_fremenu.round(2)}%.")
    else
      Arrakis.zvys_agresi_fremenu
      Imperium.zapis_operaci("Pravděpodobnost útoku fremenů se zvýšila na #{Arrakis.agresivita_fremenu.round(2)}%.")
    end
  end

end