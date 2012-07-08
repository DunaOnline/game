# encoding: utf-8
class Vypocty
  
  def self.cena_nove_planety_melanz
    zakl_cena = Constant.kmev * Constant.zakl_cena_planety
    (zakl_cena + zakl_cena * (Planet.count / (100.0 - Planet.domovske.count))).round(2)
  end
  
  def self.cena_nove_planety_solary
    zakl_cena = Constant.ksv * Constant.zakl_cena_planety * 100.0
    (zakl_cena + zakl_cena * (Planet.count / (100.0 - Planet.domovske.count))).round(0)
  end
  
  def self.cena_noveho_lena_melanz(planeta)
    zakl_cena = Constant.kmev * Constant.zakl_cena_lena
    (zakl_cena + zakl_cena * (planeta.fields.count / 100.0)).round(2)
  end
  
  def self.cena_noveho_lena_solary(planeta)
    zakl_cena = Constant.ksv * Constant.zakl_cena_lena * 100.0
    (zakl_cena + zakl_cena * (planeta.fields.count / 100.0)).round(0)
  end
  
  def self.vliv_hrace(user)
    vl = Vypocty.politicke_postaveni(user) * (user.fields.count + (user.celkova_populace / 100000.0))
    return vl.round(4)
  end
  
  def self.politicke_postaveni(user)
    pp = 1
    pp += 0.05 if user.emperor?
    pp += 0.02 if user.regent?
    pp += 0.01 if user.court?
    pp += 0.01 if user.vezir?
    pp += 0.05 if user.arrakis?
    return pp
  end
  
end