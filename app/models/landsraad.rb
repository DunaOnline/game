# encoding: utf-8
class Landsraad
  
  POMER_POSLANCE_NA_HRACE = 40
  
  def self.zapis_operaci(content, kind = "L")
    Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now).save
  end
  
  def self.pocet_poslancu
    hracu = User.count
    pocet = (hracu / Landsraad::POMER_POSLANCE_NA_HRACE) * 20
    pocet = 20 if pocet < 20
  end
  
end