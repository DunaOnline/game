# encoding: utf-8
class Constant
  # veskere konstanty jsou zde
  
  #KSP = Global.vrat('k_solar_produkce', 4)
  def ksp
    Global.vrat('k_solar_produkce', 4)
  end
  #KMAP = Global.vrat('k_material_produkce', 4)
  def kmap
    Global.vrat('k_material_produkce', 4)
  end
  #KMEP = Global.vrat('k_melanz_produkce', 4)
  def kmep
    Global.vrat('k_melanz_produkce', 4)
  end
  #KEP = Global.vrat('k_exp_produkce', 4)
  def kep
    Global.vrat('k_exp_produkce', 4)
  end
  #KPP = Global.vrat('k_population_produkce', 4)
  def kpp
    Global.vrat('k_population_produkce', 4)
  end

  #KSV = Global.vrat('k_solar_vydej', 4)
  def ksv
    Global.vrat('k_solar_vydej', 4)
  end
  #KMAV = Global.vrat('k_material_vydej', 4)
  def kmav
    Global.vrat('k_material_vydej', 4)
  end
  #KMEV = Global.vrat('k_melanz_vydej', 4)
  def kmev
    Global.vrat('k_melanz_vydej', 4)
  end
  #KEV = Global.vrat('k_exp_vydej', 4)
  def kev
    Global.vrat('k_exp_vydej', 4)
  end
  #KPV = Global.vrat('k_population_vydej', 4)
  def kpv
    Global.vrat('k_population_vydej', 4)
  end

  #KVYNOSS = Global.vrat('k_solar_vynos', 4)
  def kvynoss
    Global.vrat('k_solar_vynos', 4)
  end
  #KVYNOSMA = Global.vrat('k_material_vynos', 4)
  def kvynosma
    Global.vrat('k_material_vynos', 4)
  end
  #KVYNOSME = Global.vrat('k_melanz_vynos', 4)
  def kvynosme
    Global.vrat('k_melanz_vynos', 4)
  end
  #KVYNOSE = Global.vrat('k_exp_vynos', 4)
  def kvynose
    Global.vrat('k_exp_vynos', 4)
  end
  #KVYNOSP = Global.vrat('k_population_vynos', 4)
  def kvynosp
    Global.vrat('k_population_vynos', 4)
  end

  # aplikace
  ADMIN_EMAIL = "admin@duneonline.cz"
  
  # vypocty
  #ZAKL_CENA_NOVE_PLANETY = Global.vrat('zakl_cena_planety', 4)
  def zakl_cena_planety
    Global.vrat('zakl_cena_planety', 4)
  end

  #ZAKL_CENA_NOVEHO_LENA = Global.vrat('zakl_cena_lena', 4)
  def zakl_cena_lena
    Global.vrat('zakl_cena_lena', 4)
  end

  # planeta
  #PLANETA_DOSTUPNA_PO = Global.vrat('planeta_dostupna_po', 4)
  def planeta_dostupna_po
    Global.vrat('planeta_dostupna_po', 4)
  end

  # leno
  #BUDOV_NA_LENO = Global.vrat('budov_na_leno', 4)
  def budov_na_leno
    Global.vrat('budov_na_leno', 4)
  end
  #VYNOS_BEZ_POP = 0.1
  def vynos_bez_pop
    0.1
  end

end