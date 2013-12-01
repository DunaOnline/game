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

end