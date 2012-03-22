# encoding: utf-8
class Vypocty
  
  def self.cena_nove_planety_melanz
    zakl_cena = Constant::KMEV * Constant::ZAKL_CENA_NOVE_PLANETY
    (zakl_cena + zakl_cena * (Planet.count / (100.0 - Planet.domovske.count))).round(2)
  end
  
  def self.cena_nove_planety_solary
    zakl_cena = Constant::KSV * Constant::ZAKL_CENA_NOVE_PLANETY * 100.0
    (zakl_cena + zakl_cena * (Planet.count / (100.0 - Planet.domovske.count))).round(0)
  end
  
  def self.cena_noveho_lena_melanz(planeta)
    zakl_cena = Constant::KMEV * Constant::ZAKL_CENA_NOVEHO_LENA
    (zakl_cena + zakl_cena * (planeta.fields.count / 100.0)).round(2)
  end
  
  def self.cena_noveho_lena_solary(planeta)
    zakl_cena = Constant::KSV * Constant::ZAKL_CENA_NOVEHO_LENA * 100.0
    (zakl_cena + zakl_cena * (planeta.fields.count / 100.0)).round(0)
  end
  
end