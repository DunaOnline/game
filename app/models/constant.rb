# encoding: utf-8
class Constant
  # veskere konstanty jsou zde
  
  KSP = Global.vrat('k_solar_produkce', 4)
  KMAP = Global.vrat('k_material_produkce', 4)
  KMEP = Global.vrat('k_melanz_produkce', 4)
  KEP = Global.vrat('k_exp_produkce', 4)
  KPP = Global.vrat('k_population_produkce', 4)
  KSV = Global.vrat('k_solar_vydej', 4)
  KMAV = Global.vrat('k_material_vydej', 4)
  KMEV = Global.vrat('k_melanz_vydej', 4)
  KEV = Global.vrat('k_exp_vydej', 4)
  KPV = Global.vrat('k_population_vydej', 4)
  
  KVYNOSS = Global.vrat('k_solar_vynos', 4)
  KVYNOSMA = Global.vrat('k_material_vynos', 4)
  KVYNOSME = Global.vrat('k_melanz_vynos', 4)
  KVYNOSE = Global.vrat('k_exp_vynos', 4)
  KVYNOSP = Global.vrat('k_population_vynos', 4)
  
  # aplikace
  ADMIN_EMAIL = "admin@duneonline.cz"
  
  # vypocty
  ZAKL_CENA_NOVE_PLANETY = Global.vrat('zakl_cena_planety', 4)
  ZAKL_CENA_NOVEHO_LENA = Global.vrat('zakl_cena_lena', 4)
  
  # planeta
  PLANETA_DOSTUPNA_PO = Global.vrat('planeta_dostupna_po', 4)
  
  # leno
  BUDOV_NA_LENO = Global.vrat('budov_na_leno', 4)
  VYNOS_BEZ_POP = 0.1
  
end