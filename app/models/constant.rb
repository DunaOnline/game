# encoding: utf-8
class Constant
  # veskere konstanty jsou zde

  #KSP = Global.vrat('k_solar_produkce', 4)
  def self.ksp
    Global.vrat('k_solar_produkce', 4)
  end

  #KMAP = Global.vrat('k_material_produkce', 4)
  def self.kmap
    Global.vrat('k_material_produkce', 4)
  end

  #KMEP = Global.vrat('k_melanz_produkce', 4)
  def self.kmep
    Global.vrat('k_melanz_produkce', 4)
  end

  #KEP = Global.vrat('k_exp_produkce', 4)
  def self.kep
    Global.vrat('k_exp_produkce', 4)
  end

  #KPP = Global.vrat('k_population_produkce', 4)
  def self.kpp
    Global.vrat('k_population_produkce', 4)
  end

  #KPAP = Global.vrat('k_parts_produkce', 4)
  def self.kpap
    Global.vrat('k_parts_produkce', 4)
  end

  #KSV = Global.vrat('k_solar_vydej', 4)
  def self.ksv
    Global.vrat('k_solar_vydej', 4)
  end

  #KMAV = Global.vrat('k_material_vydej', 4)
  def self.kmav
    Global.vrat('k_material_vydej', 4)
  end

  #KMEV = Global.vrat('k_melanz_vydej', 4)
  def self.kmev
    Global.vrat('k_melanz_vydej', 4)
  end

  #KEV = Global.vrat('k_exp_vydej', 4)
  def self.kev
    Global.vrat('k_exp_vydej', 4)
  end

  #KPV = Global.vrat('k_population_vydej', 4)
  def self.kpv
    Global.vrat('k_population_vydej', 4)
  end

  #KVYNOSS = Global.vrat('k_solar_vynos', 4)
  def self.kvynoss
    Global.vrat('k_solar_vynos', 4)
  end

  #KVYNOSMA = Global.vrat('k_material_vynos', 4)
  def self.kvynosma
    Global.vrat('k_material_vynos', 4)
  end

  #KVYNOSME = Global.vrat('k_melanz_vynos', 4)
  def self.kvynosme
    Global.vrat('k_melanz_vynos', 4)
  end

  #KVYNOSE = Global.vrat('k_exp_vynos', 4)
  def self.kvynose
    Global.vrat('k_exp_vynos', 4)
  end

  #KVYNOSP = Global.vrat('k_population_vynos', 4)
  def self.kvynosp
    Global.vrat('k_population_vynos', 4)
  end

  #KVYNOSPAR = Global.vrat('k_parts_vynos', 4)
  def self.kvynospar
    Global.vrat('k_parts_vynos', 4)
  end

  # aplikace
  ADMIN_EMAIL = "admin@duneonline.cz"

  # vypocty
  #KAPACITA_TOVAREN = Global.vrat('kapacita_tovaren', 4)
  def self.kapacita_tovaren
    Global.vrat('kapacita_tovaren', 4)
  end

  #ZAKL_CENA_NOVE_PLANETY = Global.vrat('zakl_cena_planety', 4)
  def self.zakl_cena_planety
    Global.vrat('zakl_cena_planety', 4)
  end

  def self.cena_noveho_lena
	  Global.vrat('cena_noveho_lena_od_poctu',4)
  end

  #ZAKL_CENA_NOVEHO_LENA = Global.vrat('zakl_cena_lena', 4)
  def self.zakl_cena_lena
    Global.vrat('zakl_cena_lena', 4)
  end

  # planeta
  #PLANETA_DOSTUPNA_PO = Global.vrat('planeta_dostupna_po', 4)
  def self.planeta_dostupna_po
    Global.vrat('planeta_dostupna_po', 4)
  end

  # leno
  #BUDOV_NA_LENO = Global.vrat('budov_na_leno', 4)
  def self.budov_na_leno
    Global.vrat('budov_na_leno', 4)
  end

  def self.vytvor_resource_pop
	  Global.vrat('vytvor_resource_pop', 4)
  end

  def self.vytvor_resource_mat
	  Global.vrat('vytvor_resource_mat', 4)
  end


  #VYNOS_BEZ_POP = 0.1
  def self.vynos_bez_pop
    0.1
  end

  # Gilda
  def self.gilda_melanz_pevna
    Global.vrat('gilda_melanz_pevna_castka', 4)
  end

  def self.gilda_melanz_procenta
    Global.vrat('gilda_melanz_procenta', 4)
  end

  # Volby
  def self.pristi_volby
    Global.vrat('pristi_volby', 2)
  end

  def self.volba_imperatora
    Global.vrat('volba_imperatora', 1)
  end

  def self.konec_volby_imperatora
    Global.vrat('konec_volby_imperatora', 2)
  end

  def self.pravdepodobnost
    Global.vrat('pravdepodobnost_eventu', 4)
  end

  def self.pocet_udalosti
    Global.vrat('mozny_pocet_eventu_prepocet', 4)
  end

  def self.presun_leno
    Global.vrat('presun_leno', 4)
  end

  def self.presun_planeta
    Global.vrat('presun_planeta', 4)
  end

  def self.presun_vyrobku
    Global.vrat('presun_vyrobku', 4)
  end

  def self.max_u_mr
    Global.vrat('max_hracu_malorod', 4)
  end

  def self.perc_mr_obs
	  Global.vrat('perc_zalozenia_noveho_mr', 4)
  end

  def self.poc_prazdnych_mr
	  Global.vrat('pocet_prazdnych_mr', 4)
  end

  def self.rozdiel_u_reg
    Global.vrat('rozdiel_poctu_u_registracia', 4)
  end

  def self.kapacita_t_house
    Global.vrat('kapacita_tovaren_house', 4)
  end

  def self.kapacita_t_mr
    Global.vrat('kapacita_tovaren_mr', 4)
  end

  def self.stiahnut_zbozi_trh
    Global.vrat('stiahnut_zbozi_trh', 4)
  end

  def self.modifikator_produkce
    20
  end

	def self.dni_v_renegatoch
		Global.vrat('dni_v_renegatoch', 4)
	end

end