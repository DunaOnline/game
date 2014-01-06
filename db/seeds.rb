# encoding: utf-8
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)
puts 'START SEED'
House.create(:name => 'Titáni', :leader => 'The Oraculum of Time', :solar => 10000000.0, :melange => 5000.0, :material => 5000000.0, :exp => 1000.0, :playable => false, :melange_percent => 0.0)
House.create(:name => 'Impérium', :leader => 'Imperátor', :solar => 1000.0, :melange => 500.0, :material => 50000.0, :exp => 100.0, :playable => false, :melange_percent => 5.0)
House.create(:name => 'Renegáti', :leader => '', :solar => 100.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :playable => false, :melange_percent => 0.0)
House.create(:name => 'Atreides', :leader => 'Vévoda', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
House.create(:name => 'Corrino', :leader => 'Padišáh', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
House.create(:name => 'Harkonnen', :leader => 'Baron', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
House.create(:name => 'Ekaz', :leader => 'Arcivévoda', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
House.create(:name => 'Moritani', :leader => 'Vikomt', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
House.create(:name => 'Riches', :leader => 'Vévoda', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
House.create(:name => 'Vernio', :leader => 'Hrabě', :solar => 10000.0, :melange => 50.0, :material => 50000.0, :exp => 100.0, :melange_percent => 3.0)
puts 'House done'

PlanetType.create(:name => 'Měsíc', :fields => 20, :population_bonus => -25.0, :melange_bonus => 2.0, :material_bonus => 2.0, :solar_bonus => 0.0, :exp_bonus => 5.0)
PlanetType.create(:name => 'Typ Vesuvia', :fields => 35, :population_bonus => 0.0, :melange_bonus => 3.0, :material_bonus => 3.0, :solar_bonus => 0.0, :exp_bonus => 1.0)
PlanetType.create(:name => 'Pengaranský typ', :fields => 50, :population_bonus => 25.0, :melange_bonus => 5.0, :material_bonus => 2.0, :solar_bonus => 3.0, :exp_bonus => 0.0)
PlanetType.create(:name => 'Teranský typ', :fields => 65, :population_bonus => 50.0, :melange_bonus => 3.0, :material_bonus => 2.0, :solar_bonus => 4.0, :exp_bonus => 1.0)
PlanetType.create(:name => 'Dyrovský typ', :fields => 80, :population_bonus => 40.0, :melange_bonus => 2.0, :material_bonus => 3.0, :solar_bonus => 5.0, :exp_bonus => 3.0)
PlanetType.create(:name => 'Marganský typ', :fields => 95, :population_bonus => 20.0, :melange_bonus => 0.0, :material_bonus => 1.0, :solar_bonus => 3.0, :exp_bonus => 5.0)
PlanetType.create(:name => 'Asteroid', :fields => 5, :population_bonus => -50.0, :melange_bonus => 2.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0)
PlanetType.create(:name => 'Plynný obr')
PlanetType.create(:name => 'Domovská', :fields => 0, :population_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0)
puts 'PlanetType done'

domovska = PlanetType.find_by_name('Domovská')

jedna = PlanetType.find_by_name('Měsíc')
dva = PlanetType.find_by_name('Typ Vesuvia')
tri = PlanetType.find_by_name('Pengaranský typ')
ctyri = PlanetType.find_by_name('Teranský typ')
pet = PlanetType.find_by_name('Dyrovský typ')
sest = PlanetType.find_by_name('Marganský typ')

titani = House.find_by_name('Titáni')

Planet.create(:name => 'Titánia', :planet_type_id => domovska.id, :house_id => titani.id, :available_to_all => false, :discovered_at => Date.today, :position => 1, :system_name => "Titanum")
Planet.create(:name => 'Kaitan', :planet_type_id => domovska.id, :house_id => House.find_by_name('Impérium').id, :available_to_all => false, :discovered_at => Date.today, :position => 2, :system_name => "Alpha Piscium")
Planet.create(:name => 'Caladan', :planet_type_id => domovska.id, :house_id => House.find_by_name('Atreides').id, :available_to_all => false, :discovered_at => Date.today, :position => 3, :system_name => "Delta Pavonis")
Planet.create(:name => 'Salusa Secundus', :planet_type_id => domovska.id, :house_id => House.find_by_name('Corrino').id, :available_to_all => false, :discovered_at => Date.today, :position => 2, :system_name => "Salusa Centra")
Planet.create(:name => 'Giedi Prime', :planet_type_id => domovska.id, :house_id => House.find_by_name('Harkonnen').id, :available_to_all => false, :discovered_at => Date.today, :position => 1, :system_name => "Ophiuchi B 36")
Planet.create(:name => 'Ekaz', :planet_type_id => domovska.id, :house_id => House.find_by_name('Ekaz').id, :available_to_all => false, :discovered_at => Date.today, :position => 4, :system_name => "Alpha Centauri B")
Planet.create(:name => 'Gruman', :planet_type_id => domovska.id, :house_id => House.find_by_name('Moritani').id, :available_to_all => false, :discovered_at => Date.today, :posi0tion => 2, :system_name => "Niushe")
Planet.create(:name => 'Riches', :planet_type_id => domovska.id, :house_id => House.find_by_name('Riches').id, :available_to_all => false, :discovered_at => Date.today, :position => 4, :system_name => "Eridani A")
Planet.create(:name => 'Iks', :planet_type_id => domovska.id, :house_id => House.find_by_name('Vernio').id, :available_to_all => false, :discovered_at => Date.today, :position => 10, :system_name => "Rolande")
Planet.create(:name => 'Tulapin V', :planet_type_id => domovska.id, :house_id => House.find_by_name('Renegáti').id, :available_to_all => false, :discovered_at => Date.today, :position => 5, :system_name => "Tulapin Centra")
Planet.create(:name => 'Arrakis', :planet_type_id => sest.id, :house_id => House.find_by_name('Impérium').id, :available_to_all => false, :discovered_at => Date.today, :position => 1, :system_name => "Mu Draconis")
puts 'Planet done'



Global.create(:setting => 'login', :value => false)
Global.create(:setting => 'signup', :value => false)
Global.create(:setting => 'start_veku', :datum => Date.today)
Global.create(:setting => 'pristi_volby', :datum => 1.week.from_now)
Global.create(:setting => 'zakl_cena_planety', :cislo => 200.00)
Global.create(:setting => 'zakl_cena_lena', :cislo => 15.00)
Global.create(:setting => 'planeta_dostupna_po', :cislo => 4)
Global.create(:setting => 'k_solar_produkce', :cislo => 1.0)
Global.create(:setting => 'k_material_produkce', :cislo => 1.0)
Global.create(:setting => 'k_melanz_produkce', :cislo => 1.0)
Global.create(:setting => 'k_exp_produkce', :cislo => 1.0)
Global.create(:setting => 'k_population_produkce', :cislo => 1.0)
Global.create(:setting => 'k_parts_produkce', :cislo => 1.0)
Global.create(:setting => 'k_solar_vydej', :cislo => 1.0)
Global.create(:setting => 'k_material_vydej', :cislo => 1.0)
Global.create(:setting => 'k_melanz_vydej', :cislo => 1.0)
Global.create(:setting => 'k_exp_vydej', :cislo => 1.0)
Global.create(:setting => 'k_population_vydej', :cislo => 1.0)
Global.create(:setting => 'k_solar_vynos', :cislo => 100.0)
Global.create(:setting => 'k_material_vynos', :cislo => 10.0)
Global.create(:setting => 'k_melanz_vynos', :cislo => 1.0)
Global.create(:setting => 'k_exp_vynos', :cislo => 1.0)
Global.create(:setting => 'k_population_vynos', :cislo => 1000.0)
Global.create(:setting => 'k_parts_vynos', :cislo => 1.0)
Global.create(:setting => 'kapacita_tovaren', :cislo => 100.0)
Global.create(:setting => 'bezvladi_arrakis', :datum => Date.today)
Global.create(:setting => 'budov_na_leno', :cislo => 20.0)
Global.create(:setting => 'gilda_melanz_procenta', :cislo => 15.0)
Global.create(:setting => 'gilda_melanz_pevna_castka', :cislo => 100.0)
Global.create(:setting => 'volba_imperatora', :value => true)
Global.create(:setting => 'konec_volby_imperatora', :datum => 10.days.from_now)
Global.create(:setting => 'pravdepodobnost_eventu', :cislo => 2.0)
Global.create(:setting => 'mozny_pocet_eventu_prepocet', :cislo => 2.0)
Global.create(:setting => 'presun_leno', :cislo => 0.02)
Global.create(:setting => 'presun_planeta', :cislo => 0.02)
Global.create(:setting => 'presun_vyrobku', :cislo => 0.02)
Global.create(:setting => 'max_hracu_malorod', :cislo => 10)
Global.create(:setting => 'rozdiel_poctu_u_registracia', :cislo => 5)
Global.create(:setting => 'kapacita_tovaren_house', :cislo => 0.1)
Global.create(:setting => 'kapacita_tovaren_mr', :cislo => 0.05)
Global.create(:setting => 'stiahnut_zbozi_trh', :cislo => 0.7)
Global.create(:setting => 'perc_zalozenia_noveho_mr', :cislo => 0.3)
Global.create(:setting => 'pocet_prazdnych_mr', :cislo => 2)
Global.create(:setting => 'vytvor_resource_pop', :cislo => 10000)
Global.create(:setting => 'vytvor_resource_mat', :cislo => 1000)
Global.create(:setting => 'rozdiel_poctu_u_registracia', :cislo => 10)
Global.create(:setting => 'cena_noveho_lena_od_poctu', :cislo => 1)
Global.create(:setting => 'dni_v_renegatoch', :cislo => 3)
Global.create(:setting => 'cena_technology_pocet', :cislo => 1.01)
Global.create(:setting => 'cena_narodni_technology_pocet', :cislo => 1.03)
Global.create(:setting => 'presun_populace', :cislo => 0.01)
Global.create(:setting => 'presun_populace_planeta', :cislo => 0.02)
Global.create(:setting => 'naklady_upgrade_stavba_material_od_poctu', :cislo => 1.02)
Global.create(:setting => 'naklady_upgrade_stavba_melange_od_poctu', :cislo => 1.02)
Global.create(:setting => 'naklady_upgrade_stavba_solary_od_poctu', :cislo => 1.02)
Global.create(:setting => 'zapnout_nahodnou_produkci', :value => true)
Global.create(:setting => 'pocet_vyhosteni_narod', :cislo => 5)
Global.create(:setting => 'pocet_vyhosteni_mr', :cislo => 3)
Global.create(:setting => 'pocet_dni_bez_udalosti_od_zac_veku', :cislo => 3)
Global.create(:setting => 'agrese_fremenu', :cislo => 10)
Global.create(:setting => 'hranice_harvesteru', :cislo => 30)
Global.create(:setting => 'pocet_senatoru', :cislo => 20)
Global.create(:setting => 'start_veku', :datum => Date.today)
Global.create(:setting => 'odmietnutie_zakona_msg', :slovo => "Vas zakon ###self.label byl vetovan prosim klikni na link <a href='landsraad_jednani?refused=self.id>ZAKON</a>")
Global.create(:setting => 'odvolanie_imperatora_zakon_body', :slovo => "Hlasujte o duvere k imperatorovi .")
Global.create(:setting => 'odvolanie_imperatora_zakon_title', :slovo => "Ovolanie Imperatora.")
Global.create(:setting => 'malus_melanz_bezvladi', :cislo => 0.9)
Global.create(:setting => 'kapacita_kasarne', :cislo => 10)

puts 'Global done'

titania = Planet.find_by_name('Titánia')
arrakis = Arrakis.planeta
arrakis.fields << Field.new(:name => "Leno Arrakis",
                            :user_id => nil,
                            :pos_x => 1,
                            :pos_y => 1
)
puts "Leno Arrakis done"

User.create(:username => 'Norma_Cenva', :nick => 'Norma Cenva', :email => 'normacenva@spojka.vg', :house_id => titani.id, :password => 'doktoros', :password_confirmation => 'doktoros', :admin => true)
User.create(:username => 'Doktor', :nick => 'Doktor', :email => 'admin@dunaonline.cz', :house_id => titani.id, :password => 'abcd1234', :password_confirmation => 'abcd1234', :admin => true)
User.create(:username => 'Gilbertus_Albans', :nick => 'Gilbertus Albans', :email => 'administr@dunaonline.cz', :house_id => titani.id, :password => 'abcd1234', :password_confirmation => 'abcd1234', :admin => true)
User.create(:username => 'Simi', :nick => 'Simi', :email => 'administrator@dunaonline.cz', :house_id => titani.id, :password => 'abcd1234', :password_confirmation => 'abcd1234', :admin => true)
User.create(:username => 'minohimself', :nick => 'minohimself', :email => 'adminhimself@dunaonline.cz', :house_id => titani.id, :password => 'abcd1234', :password_confirmation => 'abcd1234', :admin => true)
puts 'User done'

norma = User.find_by_username('Norma_Cenva')
doktor = User.find_by_username('Doktor')
gilbertus = User.find_by_username('Gilbertus_Albans')
simi = User.find_by_username('Simi')
mino = User.find_by_username('minohimself')

Field.create(:user_id => norma.id, :planet_id => titania.id, :name => "Prvni", :pos_x => 1, :pos_y => 1)
Field.create(:user_id => doktor.id, :planet_id => titania.id, :name => "Druha", :pos_x => 1, :pos_y => 2)
Field.create(:user_id => gilbertus.id, :planet_id => titania.id, :name => "Treti", :pos_x => 2, :pos_y => 1)
Field.create(:user_id => simi.id, :planet_id => titania.id, :name => "Ctvrta", :pos_x => 2, :pos_y => 2)
Field.create(:user_id => mino.id, :planet_id => titania.id, :name => "Pata", :pos_x => 3, :pos_y => 1)
puts 'Field done'

Property.create(:name => "Asteroid",:description => "BlaBla",:image => "/img",:price => 300, :population_bonus => 1.0, :population_limit_bonus => 1.0, :melange_bonus => 1.2, :material_bonus => 1.0, :solar_bonus => 1.0,
								:exp_bonus => 1.2, :duration => 2, :population_cost => 1.0, :melange_cost => 1.0, :material_cost => 1.0, :solar_cost => 1.0, :exp_cost => 1.0, :exp_cost => 1.0, :typ => "R")
puts 'Property done'

Effect.create(:name => "Test Effect", :population_bonus => 1, :pop_limit_bonus => 1, :melange_bonus => 1, :material_bonus => 1, :solar_bonus => 1, :exp_bonus => 1, :duration => 2,
              :population_cost => 1, :melange_cost => 1, :material_cost => 1, :solar_cost => 1, :exp_cost => 1, :typ => "R", :description => "BlaBla",:image => "/img",:price => 300)
Effect.create(:name => "Renegat", :population_bonus => 1, :pop_limit_bonus => 1, :melange_bonus => 1, :material_bonus => 1, :solar_bonus => 1, :exp_bonus => 1, :duration => 2,
              :population_cost => 0.5, :melange_cost => 0.5, :material_cost => 0.5, :solar_cost => 0.5, :exp_cost => 0.5, :typ => "M", :description => "BlaBla",:image => "/img",:price => 300)
puts 'Effects done'

Technology.create(:name => "Investice do Infrastruktury", :discovered => 1, :description => "-2% cena budov
1. lvl = povolení stavby Město
7. lvl = povolení stavby Velkoměsto
14. lvl = povolení stavby Metropole", :price => 300, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "L", :image_url => "image/vyskum/i_inf.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do ekonomiky", :discovered => 1, :description => "+2% produkce solárů
1. lvl = povolení stavby Trh
7. lvl = povolení stavby Banka
14. lvl = povolení stavby Sídlo CHOAMu", :price => 300, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "S", :image_url => "image/vyskum/i_eko.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do průmyslu", :discovered => 1, :description => "+2% produkce materiálu 
1. lvl = povolení stavby Důl
7. lvl = povolení stavby Hlubinný důl
14. lvl = povolení stavby Orbitální doly", :price => 500, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "M", :image_url => "image/vyskum/i_pru.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do výzkumu", :discovered => 1, :description => "+2% produkce výzkumných bodů
1. lvl = povolení stavby Laboratoř
7. lvl = povolení stavby Výzkumné centrum
14. lvl = povolení stavby Univerzita", :price => 600, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "E", :image_url => "image/vyskum/i_vyz.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do koření", :discovered => 1, :description => "-2% ceny osídlení léna
+2% produkce melanže na Arrakis
3. lvl = povolení stavby Továrna na koření
6. lvl = povolení stavby Kasárna", :price => 250, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "J", :image_url => "image/vyskum/i_kor.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do armády", :discovered => 1, :description => "Investice do armády", :price => 400, :max_lvl => 17, :bonus => 0.02, :bonus_type => "A", :image_url => "image/vyskum/i_arm.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do výroby", :discovered => 1, :description => "+2% kapacita továren
1. lvl = povolení stavby Manufaktura
7. lvl = povolení stavby Továrna", :price => 350, :max_lvl => 10, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "V", :image_url => "image/vyskum/i_eko.png", :image_lvl => "1*7*14")

Technology.create(:name => "Investice do pěchoty", :discovered => 1, :description => "+2% kapacita kasáren
1. lvl = povolení stavby Kasárna", :price => 350, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "K", :image_url => "image/vyskum/i_eko.png", :image_lvl => "1*7*14")
Technology.create(:name => "Investice do flotily", :discovered => 1, :description => "+2% kapacita loděnic
1. lvl = povolení stavby Loděnice
7. lvl = povolení stavby Planetární obrana", :price => 350, :max_lvl => 17, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "P", :image_url => "image/vyskum/i_eko.png", :image_lvl => "1*7*14")
Technology.create(:name => "Bojová technika", :discovered => 1, :description => "+2% útok pozemních jednotek", :price => 350, :max_lvl => 15, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "PF", :image_url => "image/imghra/v011.png", :image_lvl => "1*7*14")
Technology.create(:name => "Obraná technologie", :discovered => 1, :description => "+2% HP pozemních jednotek", :price => 450, :max_lvl => 15, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "PO", :image_url => "image/imghra/v020.png", :image_lvl => "1*7*14")
Technology.create(:name => "Bojová technika", :discovered => 1, :description => "+2% útok vesmírnych jednotek", :price => 350, :max_lvl => 15, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "VF", :image_url => "image/imghra/v030.png", :image_lvl => "1*7*14")
Technology.create(:name => "Obraná technologie", :discovered => 1, :description => "+2% HP vesmírnych jednotek", :price => 300, :max_lvl => 15, :bonus => 0.02, :subhouse_bonus => 0.01, :house_bonus => 0.01, :bonus_type => "VO", :image_url => "image/imghra/v040.png", :image_lvl => "1*7*14")

#Technology.create(:name => "Lasery", :description => "", :price => 300, :max_lvl => 10, :bonus => 0.02, :bonus_type => "VO", :image_url => "image/imghra/v040.png")
#Technology.create(:name => "Rychlopalné zbraně", :description => "+2% HP vesmírnych jednotek", :price => 300, :max_lvl => 8, :bonus => 0.02, :bonus_type => "VO", :image_url => "image/imghra/v040.png")
#Technology.create(:name => "Obraná technika flotily", :description => "+2% HP vesmírnych jednotek", :price => 300, :max_lvl => 10, :bonus => 0.02, :bonus_type => "VO", :image_url => "image/imghra/v040.png")

puts 'Technology done'

Product.create(:parts => 30, :title => "Spalovac kamene", :description => "Imba iks utocna jednotka", :material => 25.5,
               :melanz => 0.5, :price => 1000, :druh => "D")
Product.create(:parts => 50, :title => "Transporter", :description => "Gilda nim vozi opice na planetu", :material => 25.5,
               :melanz => 1.75, :price => 1200, :druh => "D")

puts 'Products done'

norma.napln_suroviny
doktor.napln_suroviny
gilbertus.napln_suroviny
simi.napln_suroviny
mino.napln_suroviny
puts 'Suroviny done'

norma.hlasuj(norma, 'leader')
doktor.hlasuj(norma, 'leader')
gilbertus.hlasuj(norma, 'leader')
simi.hlasuj(norma, 'leader')
mino.hlasuj(norma, 'leader')
puts 'hlasy done'

Unit.create(:name => 'Domobrana', :house_id => 0, :description => 'Základní jednotka chranící mnohá obydlí v Impériu.', :attack => 3, :defence => 4, :health => 1, :equipment => 0, :material => 225, :solar => 525, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Legie', :house_id => 0, :description => 'Páteř každé silné armády.', :attack => 4, :defence => 3, :health => 1, :equipment => 1, :material => 228, :solar => 528, :img => '', :lvl => 3, :druh => 'pechota')
Unit.create(:name => 'Raketomet', :house_id => 0, :description => 'Jednotka, schopná ničit celé legie vojáků a strojů.', :attack => 10, :defence => 18, :health => 4, :equipment => 2, :material => 906, :solar => 2106, :img => '', :lvl => 4, :druh => 'armada')
Unit.create(:name => 'Stíhací tank', :house_id => 0, :description => 'Nejrychlejší jednotka na bitevním poli.', :attack => 16, :defence => 8, :health => 3, :equipment => 3, :material => 684, :solar => 1584, :img => '', :lvl => 3, :druh => 'boj_technika')
Unit.create(:name => 'Landsraadni garda', :house_id => 0, :description => 'Elitní jednotky v Imperiu školené Ginázskými mistry meče. ', :attack => 5, :defence => 9, :health => 2, :equipment => 2, :material => 456, :solar => 1056, :img => '', :lvl => 3, :druh => 'obr_technika')
Unit.create(:name => 'Pozemní holtzmanův generátor', :house_id => 0, :description => 'Velice drahá vojenská mechanizace, která je schopna ochnánit celé legie či města.', :attack => 7, :defence => 20, :health => 1, :equipment => 2, :material => 831, :solar => 1931, :img => '', :lvl => 10, :druh => 'obr_technika')
Unit.create(:name => 'Sonický tank', :house_id => House.find_by_name('Atreides').id, :description => '', :attack => 18, :defence => 6, :health => 4, :equipment => 3, :material => 789, :solar => 1829, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Hradní stráž', :house_id => House.find_by_name('Atreides').id, :description => 'Univerzální národní jednotka vhodná pro boj i obranu.', :attack => 6, :defence => 6, :health => 2, :equipment => 1, :material => 393, :solar => 913, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Četa sardaukarů', :house_id => House.find_by_name('Corrino').id, :description => '', :attack => 9, :defence => 9, :health => 3, :equipment => 2, :material => 591, :solar => 1371, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Četa s bašárem', :house_id => House.find_by_name('Corrino').id, :description => '', :attack => 16, :defence => 8, :health => 4, :equipment => 2, :material => 786, :solar => 1826, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Vévodova garda', :house_id => House.find_by_name('Ekaz').id, :description => '', :attack => 4, :defence => 2, :health => 1, :equipment => 2, :material => 201, :solar => 461, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Mistři meče', :house_id => House.find_by_name('Ekaz').id, :description => '', :attack => 10, :defence => 8, :health => 3, :equipment => 2, :material => 591, :solar => 1371, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Devastátor', :house_id => House.find_by_name('Harkonnen').id, :description => '', :attack => 20, :defence => 10, :health => 5, :equipment => 4, :material => 987, :solar => 2287, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Halda ozbrojený otroků', :house_id => House.find_by_name('Harkonnen').id, :description => '', :attack => 2, :defence => 4, :health => 1, :equipment => 0, :material => 195, :solar => 455, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Garda Vimkomta', :house_id => House.find_by_name('Moritani').id, :description => 'Jednotka sloužicí k ochraně domovských světů.', :attack => 5, :defence => 7, :health => 2, :equipment => 2, :material => 396, :solar => 916, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Assasin', :house_id => House.find_by_name('Moritani').id, :description => 'Vyškolený zabiják zabijáků.', :attack => 8, :defence => 4, :health => 2, :equipment => 2, :material => 396, :solar => 916, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Kyborg', :house_id => House.find_by_name('Riches').id, :description => 'Elitní národní jednotka, která je určena pro pozemní boj.', :attack => 10, :defence => 8, :health => 3, :equipment => 3, :material => 594, :solar => 1374, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Laserové dělo', :house_id => House.find_by_name('Riches').id, :description => 'Není lepšího nástroje na porcování nepřátel!', :attack => 6, :defence => 18, :health => 4, :equipment => 1, :material => 783, :solar => 1823, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Slídič', :house_id => House.find_by_name('Vernio').id, :description => 'Elitní národní jednotka, která je určena pro napadení ze zálohy.', :attack => 4, :defence => 2, :health => 1, :equipment => 1, :material => 198, :solar => 458, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Štítonoši', :house_id => House.find_by_name('Vernio').id, :description => 'Univerzální národní jednotka vhodná pro boj i obranu.', :attack => 3, :defence => 3, :health => 1, :equipment => 1, :material => 204, :solar => 464, :img => '', :lvl => nil, :druh => '')
Unit.create(:name => 'Imperiální garda', :house_id => House.find_by_name('Impérium').id, :description => 'Jednotka pro pravého císaře školena na Ginazu.', :attack => 10, :defence => 5, :health => 3, :equipment => 1, :material => 507, :solar => 1167, :img => '', :lvl => nil, :druh => '')


Building.create(:kind => "L", :level => 1, :name => "Město", :description => "Města slouží k ubytování vaší populace.", :population_bonus => 20.0, :pop_limit_bonus => 20.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 35.0, :solar_cost => 30.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "L", :level => 2, :name => "Velkoměsto", :description => "Velkoměsta slouží k ubytování vaší populace.", :population_bonus => 30.0, :pop_limit_bonus => 30.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 36.0, :solar_cost => 32.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "L", :level => 3, :name => "Metropole", :description => "Metropole slouží k ubytování vaší populace.", :population_bonus => 50.0, :pop_limit_bonus => 50.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 5.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 1.0, :material_cost => 37.0, :solar_cost => 33.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "S", :level => 1, :name => "Trh", :description => "Trhy slouží k produkci solárů, což je hlavní platidlo v Impériu. ", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 10.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 25.0, :solar_cost => 20.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "S", :level => 2, :name => "Banka", :description => "Banka slouží k produkci solárů, což je hlavní platidlo v Impériu. ", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 14.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 26.0, :solar_cost => 22.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "S", :level => 3, :name => "Burza", :description => "Burza slouží k produkci solárů, což je hlavní platidlo v Impériu. ", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 18.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 27.0, :solar_cost => 23.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "M", :level => 1, :name => "Důl", :description => "Doly slouží k těžbě vzácných rud, které jsou dále zpracovány na materiál.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 10.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 20.0, :solar_cost => 21.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "M", :level => 2, :name => "Vrt", :description => "Vrt slouží k těžbě vzácných rud, které jsou dále zpracovány na materiál.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 14.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 21.0, :solar_cost => 22.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "M", :level => 3, :name => "Hlubinná těžba", :description => "Hlubinna tezba slouží k těžbě vzácných rud, které jsou dále zpracovány na materiál.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 18.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 22.0, :solar_cost => 23.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "E", :level => 1, :name => "Laboratoř", :description => "Laboratoře jsou určeny k produkci zkušeností (expů), ty jsou dále využity pro výzkum technologii.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 10.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 40.0, :solar_cost => 30.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "E", :level => 2, :name => "Univerzita", :description => "Univerzity jsou určeny k produkci zkušeností (expů), ty jsou dále využity pro výzkum technologii.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 14.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 42.0, :solar_cost => 31.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "E", :level => 3, :name => "Chrám vědy", :description => "Chramy vedy jsou určeny k produkci zkušeností (expů), ty jsou dále využity pro výzkum technologii.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 18.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 44.0, :solar_cost => 32.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")

Building.create(:kind => "O", :level => 1, :name => "PO", :description => "Planetarni obrana.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 70.0, :solar_cost => 100.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "V", :level => 1, :name => "Továrna", :description => "Produkuje vyrobky.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 0.0, :material_cost => 75.0, :solar_cost => 50.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "VK", :level => 1, :name => "Kasarna", :description => "Produkuje vojaky.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 0.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 200.0, :melange_cost => 5.0, :material_cost => 75.0, :solar_cost => 50.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")

Building.create(:kind => "J", :level => 1, :name => "Továrna na koření", :description => "Produkuje koreni.", :population_bonus => 0.0, :pop_limit_bonus => 0.0, :melange_bonus => 100.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 20.0, :melange_cost => 3.0, :material_cost => 50.0, :solar_cost => 100.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
Building.create(:kind => "JL", :level => 1, :name => "Arraken", :description => "Sídelní město, astroport.", :population_bonus => 10.0, :pop_limit_bonus => 0.0, :melange_bonus => 300.0, :material_bonus => 0.0, :solar_bonus => 0.0, :exp_bonus => 0.0, :population_cost => 0.0, :melange_cost => 0.0, :material_cost => 0.0, :solar_cost => 0.0, :exp_cost => 0.0, :prerequisity_1 => "", :prerequisity_2 => "", :prerequisity_3 => "")
puts 'budovy done'

arrakis_field = Field.find_by_planet_id(arrakis)
arraken = Building.where(:name => "Arraken").first
arrakis_field.postav(arraken, 1)
harvester = Building.where(:name => "Továrna na koření").first
arrakis_field.postav(harvester, 10)
puts "Budovy na Arrakis postaveny"

Discoverable.create(:name => 'Titánia', :planet_type_id => 5, :discovered => true, :system_name => "Titanum", :position => 1)
Discoverable.create(:name => 'Aclin', :planet_type_id => 1, :discovered => false, :system_name => "Aclin Neutra", :position => 1)
Discoverable.create(:name => 'Aclin II', :planet_type_id => 1, :discovered => false, :system_name => "Aclin Neutra", :position => 2)
Discoverable.create(:name => 'Al-Dhaneb', :planet_type_id => 2, :discovered => false, :system_name => "Delphinus", :position => 1)
Discoverable.create(:name => 'Zamar', :planet_type_id => 3, :discovered => false, :system_name => "Delphinus", :position => 2)
Discoverable.create(:name => 'Anbus I', :planet_type_id => 1, :discovered => false, :system_name => "Anbus", :position => 1)
Discoverable.create(:name => 'Anbus II', :planet_type_id => 1, :discovered => false, :system_name => "Anbus", :position => 2)
Discoverable.create(:name => 'Anbus III', :planet_type_id => 1, :discovered => false, :system_name => "Anbus", :position => 3)
Discoverable.create(:name => 'Anbus IV', :planet_type_id => 3, :discovered => false, :system_name => "Anbus", :position => 4)
Discoverable.create(:name => 'Andloy', :planet_type_id => 1, :discovered => false, :system_name => "Aclin Beta", :position => 1)
Discoverable.create(:name => 'Arbelough', :planet_type_id => 1, :discovered => false, :system_name => "Eridani C", :position => 1)
Discoverable.create(:name => 'Arrakis', :planet_type_id => 3, :discovered => true, :system_name => "Mu Draconis", :position => 1)
Discoverable.create(:name => 'Atar', :planet_type_id => 4, :discovered => false, :system_name => "Atari", :position => 1)
Discoverable.create(:name => 'Atar II', :planet_type_id => 1, :discovered => false, :system_name => "Atari", :position => 2)
Discoverable.create(:name => 'Atar III', :planet_type_id => 6, :discovered => false, :system_name => "Atari", :position => 3)
Discoverable.create(:name => 'Atar IV', :planet_type_id => 1, :discovered => false, :system_name => "Atari", :position => 4)
Discoverable.create(:name => 'Belner', :planet_type_id => 1, :discovered => false, :system_name => "Balút", :position => 1)
Discoverable.create(:name => 'Balút', :planet_type_id => 3, :discovered => false, :system_name => "Balút", :position => 2)
Discoverable.create(:name => 'Barandik', :planet_type_id => 4, :discovered => false, :system_name => "Barandik", :position => 1)
Discoverable.create(:name => 'Bela Tegeuse I', :planet_type_id => 2, :discovered => false, :system_name => "Kuentsing", :position => 1)
Discoverable.create(:name => 'Bela Tegeuse II', :planet_type_id => 2, :discovered => false, :system_name => "Kuentsing", :position => 2)
Discoverable.create(:name => 'Bela Tegeuse III', :planet_type_id => 1, :discovered => false, :system_name => "Kuentsing", :position => 3)
Discoverable.create(:name => 'Bela Tegeuse IV', :planet_type_id => 1, :discovered => false, :system_name => "Kuentsing", :position => 4)
Discoverable.create(:name => 'Bela Tegeuse V', :planet_type_id => 5, :discovered => false, :system_name => "Kuentsing", :position => 5)
Discoverable.create(:name => 'Biarek', :planet_type_id => 6, :discovered => false, :system_name => "Alastria", :position => 1)
Discoverable.create(:name => 'Alastria', :planet_type_id => 3, :discovered => false, :system_name => "Alastria", :position => 2)
Discoverable.create(:name => 'Bifkar', :planet_type_id => 4, :discovered => false, :system_name => "Norma Cenva", :position => 1)
Discoverable.create(:name => 'Buzell', :planet_type_id => 5, :discovered => false, :system_name => "Buzell Alpha", :position => 1)
Discoverable.create(:name => 'Beakkal', :planet_type_id => 3, :discovered => false, :system_name => "Beakkal Centa", :position => 1)
Discoverable.create(:name => 'Danuun', :planet_type_id => 2, :discovered => false, :system_name => "Alpha Centauri A", :position => 1)
Discoverable.create(:name => 'Dan', :planet_type_id => 2, :discovered => false, :system_name => "Alpha Centauri A", :position => 2)
Discoverable.create(:name => 'Caladan', :planet_type_id => 6, :discovered => true, :system_name => "Alpha Centauri A", :position => 3)
Discoverable.create(:name => 'Letona', :planet_type_id => 3, :discovered => false, :system_name => "Alpha Centauri A", :position => 4)
Discoverable.create(:name => 'Canidar I', :planet_type_id => 1, :discovered => false, :system_name => "Eridani B", :position => 1)
Discoverable.create(:name => 'Canidar II', :planet_type_id => 3, :discovered => false, :system_name => "Eridani B", :position => 2)
Discoverable.create(:name => 'Cerbol', :planet_type_id => 2, :discovered => false, :system_name => "Cerbol Leta", :position => 1)
Discoverable.create(:name => 'Boreth', :planet_type_id => 1, :discovered => false, :system_name => "Cerbol Leta", :position => 2)
Discoverable.create(:name => 'Danu I', :planet_type_id => 1, :discovered => false, :system_name => "Danu", :position => 1)
Discoverable.create(:name => 'Danu II', :planet_type_id => 1, :discovered => false, :system_name => "Danu", :position => 2)
Discoverable.create(:name => 'Danu III', :planet_type_id => 3, :discovered => false, :system_name => "Danu", :position => 3)
Discoverable.create(:name => 'Danu IV', :planet_type_id => 4, :discovered => false, :system_name => "Danu", :position => 4)
Discoverable.create(:name => 'Dur', :planet_type_id => 4, :discovered => false, :system_name => "Dur", :position => 1)
Discoverable.create(:name => 'Habla', :planet_type_id => 2, :discovered => false, :system_name => "Alpha Centauri B", :position => 1)
Discoverable.create(:name => 'Hufuf', :planet_type_id => 2, :discovered => false, :system_name => "Alpha Centauri B", :position => 2)
Discoverable.create(:name => 'Ellaka', :planet_type_id => 3, :discovered => false, :system_name => "Alpha Centauri B", :position => 3)
Discoverable.create(:name => 'Ekaz', :planet_type_id => 4, :discovered => true, :system_name => "Alpha Centauri B", :position => 4)
Discoverable.create(:name => 'Enfeil', :planet_type_id => 6, :discovered => false, :system_name => "Enfeil Vacca", :position => 1)
Discoverable.create(:name => 'Enfeil Dabai', :planet_type_id => 1, :discovered => false, :system_name => "Enfeil Vacca", :position => 2)
Discoverable.create(:name => 'Gaar I ', :planet_type_id => 2, :discovered => false, :system_name => "Gaar", :position => 1)
Discoverable.create(:name => 'Gaar II', :planet_type_id => 2, :discovered => false, :system_name => "Gaar", :position => 2)
Discoverable.create(:name => 'Gaar III', :planet_type_id => 3, :discovered => false, :system_name => "Gaar", :position => 3)
Discoverable.create(:name => 'Gamont', :planet_type_id => 4, :discovered => false, :system_name => "Niushe", :position => 3)
Discoverable.create(:name => 'Grumman', :planet_type_id => 3, :discovered => true, :system_name => "Niushe", :position => 2)
Discoverable.create(:name => 'Niusche', :planet_type_id => 4, :discovered => false, :system_name => "Niushe", :position => 4)
Discoverable.create(:name => 'Giedi Prima', :planet_type_id => 3, :discovered => true, :system_name => "Ophiuchi B 36", :position => 1)
Discoverable.create(:name => 'Sikun', :planet_type_id => 3, :discovered => false, :system_name => "Ophiuchi B 36", :position => 2)
Discoverable.create(:name => 'Lampadas', :planet_type_id => 5, :discovered => false, :system_name => "Ophiuchi B 36", :position => 3)
Discoverable.create(:name => 'Trobo', :planet_type_id => 2, :discovered => false, :system_name => "I Theta Shaowei", :position => 1)
Discoverable.create(:name => 'Trina', :planet_type_id => 3, :discovered => false, :system_name => "I Theta Shaowei", :position => 2)
Discoverable.create(:name => 'Gináz', :planet_type_id => 6, :discovered => false, :system_name => "I Theta Shaowei", :position => 3)
Discoverable.create(:name => 'Hagal Deva', :planet_type_id => 1, :discovered => false, :system_name => "II Theta Shaowei", :position => 1)
Discoverable.create(:name => 'Hagal Nocturna', :planet_type_id => 5, :discovered => false, :system_name => "II Theta Shaowei", :position => 2)
Discoverable.create(:name => 'Hagal', :planet_type_id => 3, :discovered => false, :system_name => "II Theta Shaowei", :position => 3)
Discoverable.create(:name => 'Pavonis II', :planet_type_id => 5, :discovered => false, :system_name => "Delta Pavonis", :position => 2)
Discoverable.create(:name => 'Harmonthep', :planet_type_id => 3, :discovered => false, :system_name => "Delta Pavonis", :position => 3)
Discoverable.create(:name => 'Iks (Xuttuh)', :planet_type_id => 5, :discovered => true, :system_name => "Delta Pavonis", :position => 10)
Discoverable.create(:name => 'Shalish I', :planet_type_id => 1, :discovered => false, :system_name => "Theta Shalish", :position => 1)
Discoverable.create(:name => 'Shalish II', :planet_type_id => 1, :discovered => false, :system_name => "Theta Shalish", :position => 2)
Discoverable.create(:name => 'Shalish III', :planet_type_id => 1, :discovered => false, :system_name => "Theta Shalish", :position => 3)
Discoverable.create(:name => 'Chusúk', :planet_type_id => 4, :discovered => false, :system_name => "Theta Shalish", :position => 4)
Discoverable.create(:name => 'Lernaeus', :planet_type_id => 4, :discovered => false, :system_name => "Theta Shalish", :position => 5)
Discoverable.create(:name => 'Alangue I', :planet_type_id => 1, :discovered => false, :system_name => "Epsilon Alangue", :position => 1)
Discoverable.create(:name => 'Alangue II', :planet_type_id => 1, :discovered => false, :system_name => "Epsilon Alangue", :position => 2)
Discoverable.create(:name => 'Alangue III', :planet_type_id => 1, :discovered => false, :system_name => "Epsilon Alangue", :position => 3)
Discoverable.create(:name => 'Alangue IV', :planet_type_id => 2, :discovered => false, :system_name => "Epsilon Alangue", :position => 4)
Discoverable.create(:name => 'Kadiš', :planet_type_id => 2, :discovered => false, :system_name => "Epsilon Alangue", :position => 5)
Discoverable.create(:name => 'Alangue VI ', :planet_type_id => 1, :discovered => false, :system_name => "Epsilon Alangue", :position => 6)
Discoverable.create(:name => 'Alangue VII', :planet_type_id => 3, :discovered => false, :system_name => "Epsilon Alangue", :position => 7)
Discoverable.create(:name => 'Korint', :planet_type_id => 3, :discovered => false, :system_name => "Alpha Piscium", :position => 1)
Discoverable.create(:name => 'Kaitan', :planet_type_id => 4, :discovered => true, :system_name => "Alpha Piscium", :position => 2)
Discoverable.create(:name => 'Piscium', :planet_type_id => 5, :discovered => false, :system_name => "Alpha Piscium", :position => 3)
Discoverable.create(:name => 'Kirana Alef I', :planet_type_id => 1, :discovered => false, :system_name => "Kirana Alef", :position => 1)
Discoverable.create(:name => 'Kirana Alef II', :planet_type_id => 3, :discovered => false, :system_name => "Kirana Alef", :position => 2)
Discoverable.create(:name => 'Kirana Alef III', :planet_type_id => 1, :discovered => false, :system_name => "Kirana Alef", :position => 3)
Discoverable.create(:name => 'Kirana Alef IV', :planet_type_id => 5, :discovered => false, :system_name => "Kirana Alef", :position => 4)
Discoverable.create(:name => 'Kronin', :planet_type_id => 2, :discovered => false, :system_name => "Krona Centa", :position => 1)
Discoverable.create(:name => 'Herculis I', :planet_type_id => 2, :discovered => false, :system_name => "Beta Herculis", :position => 1)
Discoverable.create(:name => 'Herculis II', :planet_type_id => 1, :discovered => false, :system_name => "Beta Herculis", :position => 2)
Discoverable.create(:name => 'Herculis III', :planet_type_id => 1, :discovered => false, :system_name => "Beta Herculis", :position => 3)
Discoverable.create(:name => 'Heculis IV', :planet_type_id => 1, :discovered => false, :system_name => "Beta Herculis", :position => 4)
Discoverable.create(:name => 'Lankiveil', :planet_type_id => 6, :discovered => false, :system_name => "Beta Herculis", :position => 5)
Discoverable.create(:name => 'Markon', :planet_type_id => 2, :discovered => false, :system_name => "Markona Prime", :position => 1)
Discoverable.create(:name => 'Molitor', :planet_type_id => 3, :discovered => false, :system_name => "Sirius A", :position => 1)
Discoverable.create(:name => 'Calibra', :planet_type_id => 1, :discovered => false, :system_name => "Sirius A", :position => 2)
Discoverable.create(:name => 'Muritan', :planet_type_id => 4, :discovered => false, :system_name => "Sirius B", :position => 1)
Discoverable.create(:name => 'Narádž I', :planet_type_id => 1, :discovered => false, :system_name => "Narádž", :position => 1)
Discoverable.create(:name => 'Narádž II', :planet_type_id => 2, :discovered => false, :system_name => "Narádž", :position => 2)
Discoverable.create(:name => 'Narádž III', :planet_type_id => 3, :discovered => false, :system_name => "Narádž", :position => 3)
Discoverable.create(:name => 'Narádž VI', :planet_type_id => 5, :discovered => false, :system_name => "Narádž", :position => 5)
Discoverable.create(:name => 'Narádž VI', :planet_type_id => 6, :discovered => false, :system_name => "Narádž", :position => 7)
Discoverable.create(:name => 'Niazi', :planet_type_id => 5, :discovered => false, :system_name => "Niazi", :position => 1)
Discoverable.create(:name => 'Niazi Dua', :planet_type_id => 1, :discovered => false, :system_name => "Niazi", :position => 2)
Discoverable.create(:name => 'Novebruns', :planet_type_id => 5, :discovered => false, :system_name => "Mettuli", :position => 3)
Discoverable.create(:name => 'Palma', :planet_type_id => 2, :discovered => false, :system_name => "Mettuli", :position => 2)
Discoverable.create(:name => 'Parella', :planet_type_id => 4, :discovered => false, :system_name => "Camelopardalis", :position => 1)
Discoverable.create(:name => 'Pilargo', :planet_type_id => 6, :discovered => false, :system_name => "Coma Berenices", :position => 1)
Discoverable.create(:name => 'Ponciard', :planet_type_id => 2, :discovered => false, :system_name => "Hydra", :position => 1)
Discoverable.create(:name => 'Alangue I', :planet_type_id => 2, :discovered => false, :system_name => "Epsilon Alangue", :position => 1)
Discoverable.create(:name => 'Alangue II', :planet_type_id => 1, :discovered => false, :system_name => "Epsilon Alangue", :position => 2)
Discoverable.create(:name => 'Poritrin', :planet_type_id => 4, :discovered => false, :system_name => "Epsilon Alangue", :position => 3)
Discoverable.create(:name => 'Alangue IV', :planet_type_id => 3, :discovered => false, :system_name => "Epsilon Alangue", :position => 4)
Discoverable.create(:name => 'Selestis', :planet_type_id => 1, :discovered => false, :system_name => "Alfa Selestis", :position => 2)
Discoverable.create(:name => 'Reenol', :planet_type_id => 4, :discovered => false, :system_name => "Alfa Selestis", :position => 1)
Discoverable.create(:name => 'Renditai', :planet_type_id => 3, :discovered => false, :system_name => "Fornax", :position => 1)
Discoverable.create(:name => 'Eridani I', :planet_type_id => 1, :discovered => false, :system_name => "Eridani A", :position => 1)
Discoverable.create(:name => 'Eridani II', :planet_type_id => 1, :discovered => false, :system_name => "Eridani A", :position => 2)
Discoverable.create(:name => 'Eridani III', :planet_type_id => 6, :discovered => false, :system_name => "Eridani A", :position => 3)
Discoverable.create(:name => 'Riches', :planet_type_id => 4, :discovered => true, :system_name => "Eridani A", :position => 4)
Discoverable.create(:name => 'Rigel I', :planet_type_id => 2, :discovered => false, :system_name => "Rigel", :position => 1)
Discoverable.create(:name => 'Rigel II', :planet_type_id => 2, :discovered => false, :system_name => "Rigel", :position => 2)
Discoverable.create(:name => 'Rigel III', :planet_type_id => 1, :discovered => false, :system_name => "Rigel", :position => 3)
Discoverable.create(:name => 'Rigel IV', :planet_type_id => 1, :discovered => false, :system_name => "Rigel", :position => 4)
Discoverable.create(:name => 'Rigel V', :planet_type_id => 5, :discovered => false, :system_name => "Rigel", :position => 5)
Discoverable.create(:name => 'Rigel VI', :planet_type_id => 1, :discovered => false, :system_name => "Rigel", :position => 6)
Discoverable.create(:name => 'Risp I', :planet_type_id => 2, :discovered => false, :system_name => "Risp Centra", :position => 1)
Discoverable.create(:name => 'Risp II', :planet_type_id => 2, :discovered => false, :system_name => "Risp Centra", :position => 2)
Discoverable.create(:name => 'Risp III', :planet_type_id => 2, :discovered => false, :system_name => "Risp Centra", :position => 3)
Discoverable.create(:name => 'Risp IV', :planet_type_id => 1, :discovered => false, :system_name => "Risp Centra", :position => 4)
Discoverable.create(:name => 'Risp V', :planet_type_id => 1, :discovered => false, :system_name => "Risp Centra", :position => 5)
Discoverable.create(:name => 'Risp VI', :planet_type_id => 1, :discovered => false, :system_name => "Risp Centra", :position => 6)
Discoverable.create(:name => 'Risp VII', :planet_type_id => 3, :discovered => false, :system_name => "Risp Centra", :position => 7)
Discoverable.create(:name => 'Rocu', :planet_type_id => 2, :discovered => false, :system_name => "Leo Minor", :position => 1)
Discoverable.create(:name => 'Minor', :planet_type_id => 1, :discovered => false, :system_name => "Leo Minor", :position => 2)
Discoverable.create(:name => 'Horologium', :planet_type_id => 3, :discovered => false, :system_name => "Leo Minor", :position => 3)
Discoverable.create(:name => 'Rom', :planet_type_id => 5, :discovered => false, :system_name => "Microscopium", :position => 1)
Discoverable.create(:name => 'Lupus', :planet_type_id => 4, :discovered => false, :system_name => "Microscopium", :position => 2)
Discoverable.create(:name => 'Musca', :planet_type_id => 1, :discovered => false, :system_name => "Microscopium", :position => 3)
Discoverable.create(:name => 'Octans', :planet_type_id => 1, :discovered => false, :system_name => "Microscopium", :position => 4)
Discoverable.create(:name => 'Rossak', :planet_type_id => 5, :discovered => false, :system_name => "Piscis Austrinus", :position => 1)
Discoverable.create(:name => 'Salusa Primus', :planet_type_id => 2, :discovered => false, :system_name => "Salusa Centra", :position => 1)
Discoverable.create(:name => 'Salusa Secundus', :planet_type_id => 3, :discovered => true, :system_name => "Salusa Centra", :position => 2)
Discoverable.create(:name => 'Semba I', :planet_type_id => 2, :discovered => false, :system_name => "Semba", :position => 1)
Discoverable.create(:name => 'Semba II', :planet_type_id => 1, :discovered => false, :system_name => "Semba", :position => 2)
Discoverable.create(:name => 'Semba III', :planet_type_id => 1, :discovered => false, :system_name => "Semba", :position => 3)
Discoverable.create(:name => 'Semba IV', :planet_type_id => 3, :discovered => false, :system_name => "Semba", :position => 4)
Discoverable.create(:name => 'Seprek', :planet_type_id => 4, :discovered => false, :system_name => "Virgo", :position => 3)
Discoverable.create(:name => 'Vela', :planet_type_id => 3, :discovered => false, :system_name => "Virgo", :position => 4)
Discoverable.create(:name => 'Tarahell', :planet_type_id => 2, :discovered => false, :system_name => "Ursa Minor", :position => 1)
Discoverable.create(:name => 'Tulapin I', :planet_type_id => 1, :discovered => false, :system_name => "Tulapin Centra", :position => 1)
Discoverable.create(:name => 'Tulapin II', :planet_type_id => 1, :discovered => false, :system_name => "Tulapin Centra", :position => 2)
Discoverable.create(:name => 'Tulapin III', :planet_type_id => 1, :discovered => false, :system_name => "Tulapin Centra", :position => 3)
Discoverable.create(:name => 'Tulapin IV', :planet_type_id => 1, :discovered => false, :system_name => "Tulapin Centra", :position => 4)
Discoverable.create(:name => 'Tulapin V', :planet_type_id => 4, :discovered => true, :system_name => "Tulapin Centra", :position => 5)
Discoverable.create(:name => 'Zabulon I', :planet_type_id => 2, :discovered => false, :system_name => "Zabulon", :position => 1)
Discoverable.create(:name => 'Zabulon II', :planet_type_id => 1, :discovered => false, :system_name => "Zabulon", :position => 2)
Discoverable.create(:name => 'Zabulon III', :planet_type_id => 3, :discovered => false, :system_name => "Zabulon", :position => 3)
Discoverable.create(:name => 'Zabulon IV', :planet_type_id => 4, :discovered => false, :system_name => "Zabulon", :position => 4)
Discoverable.create(:name => 'Zabulon V', :planet_type_id => 1, :discovered => false, :system_name => "Zabulon", :position => 5)
Discoverable.create(:name => 'Zanovar', :planet_type_id => 4, :discovered => false, :system_name => "Taligari", :position => 2)
Discoverable.create(:name => 'Kaising I', :planet_type_id => 5, :discovered => false, :system_name => "III Delta Kaising", :position => 1)
Discoverable.create(:name => 'Kaising II', :planet_type_id => 1, :discovered => false, :system_name => "III Delta Kaising", :position => 2)
Discoverable.create(:name => 'Chonsu I', :planet_type_id => 2, :discovered => false, :system_name => "Revana Una", :position => 1)
Discoverable.create(:name => 'Chonsu II', :planet_type_id => 1, :discovered => false, :system_name => "Revana Una", :position => 2)
Discoverable.create(:name => 'Revana', :planet_type_id => 4, :discovered => false, :system_name => "Revana Una", :position => 3)
Discoverable.create(:name => 'Arana I', :planet_type_id => 2, :discovered => false, :system_name => "Arana", :position => 1)
Discoverable.create(:name => 'Arana II', :planet_type_id => 3, :discovered => false, :system_name => "Arana", :position => 2)
Discoverable.create(:name => 'Himaltar', :planet_type_id => 1, :discovered => false, :system_name => "Arana", :position => 3)
Discoverable.create(:name => 'Alara I', :planet_type_id => 2, :discovered => false, :system_name => "Septum I", :position => 1)
Discoverable.create(:name => 'Alara II', :planet_type_id => 1, :discovered => false, :system_name => "Septum I", :position => 2)
Discoverable.create(:name => 'Alara III', :planet_type_id => 1, :discovered => false, :system_name => "Septum I", :position => 3)
Discoverable.create(:name => 'Alara IV', :planet_type_id => 1, :discovered => false, :system_name => "Septum I", :position => 4)
Discoverable.create(:name => 'Alara V', :planet_type_id => 4, :discovered => false, :system_name => "Septum I", :position => 5)
Discoverable.create(:name => 'Alara VI', :planet_type_id => 3, :discovered => false, :system_name => "Septum I", :position => 6)
Discoverable.create(:name => 'Alara VII', :planet_type_id => 1, :discovered => false, :system_name => "Septum I", :position => 7)
Discoverable.create(:name => 'Aralon', :planet_type_id => 5, :discovered => false, :system_name => "Septum II", :position => 1)
Discoverable.create(:name => 'Barinx', :planet_type_id => 1, :discovered => false, :system_name => "Septum II", :position => 2)
Discoverable.create(:name => 'Centuri I', :planet_type_id => 2, :discovered => false, :system_name => "Alfa Centuri", :position => 1)
Discoverable.create(:name => 'Centuri II', :planet_type_id => 3, :discovered => false, :system_name => "Alfa Centuri", :position => 2)
Discoverable.create(:name => 'Dallar', :planet_type_id => 2, :discovered => false, :system_name => "Triangulum Australe", :position => 1)
Discoverable.create(:name => 'Falkan', :planet_type_id => 2, :discovered => false, :system_name => "Triangulum Australe", :position => 2)
Discoverable.create(:name => 'Wallach III', :planet_type_id => 2, :discovered => false, :system_name => "Triangulum Australe", :position => 3)
Discoverable.create(:name => 'Wallach IV', :planet_type_id => 2, :discovered => false, :system_name => "Triangulum Australe", :position => 4)
Discoverable.create(:name => 'Wallach V', :planet_type_id => 1, :discovered => false, :system_name => "Triangulum Australe", :position => 5)
Discoverable.create(:name => 'Wallach VI ', :planet_type_id => 1, :discovered => false, :system_name => "Triangulum Australe", :position => 6)
Discoverable.create(:name => 'Drebin', :planet_type_id => 4, :discovered => false, :system_name => "Triangulum Australe", :position => 7)
Discoverable.create(:name => 'Wallach VIII', :planet_type_id => 1, :discovered => false, :system_name => "Triangulum Australe", :position => 8)
Discoverable.create(:name => 'Wallach IX', :planet_type_id => 6, :discovered => false, :system_name => "Triangulum Australe", :position => 9)
Discoverable.create(:name => 'Galorn', :planet_type_id => 3, :discovered => false, :system_name => "Galorn", :position => 1)
Discoverable.create(:name => 'Kliban', :planet_type_id => 4, :discovered => false, :system_name => "Galorn", :position => 2)
Discoverable.create(:name => 'Nytet', :planet_type_id => 6, :discovered => false, :system_name => "Galorn", :position => 3)
Discoverable.create(:name => 'Lingora', :planet_type_id => 6, :discovered => false, :system_name => "Lingora", :position => 1)
Discoverable.create(:name => 'Huwi I', :planet_type_id => 1, :discovered => false, :system_name => "II Delta Kaising", :position => 1)
Discoverable.create(:name => 'Huwi II', :planet_type_id => 1, :discovered => false, :system_name => "II Delta Kaising", :position => 2)
Discoverable.create(:name => 'Zeta Dian', :planet_type_id => 2, :discovered => false, :system_name => "Zeta Olympus", :position => 1)
Discoverable.create(:name => 'Olymp', :planet_type_id => 4, :discovered => false, :system_name => "Zeta Olympus", :position => 2)
Discoverable.create(:name => 'Zeta II', :planet_type_id => 1, :discovered => false, :system_name => "Zeta Olympus", :position => 3)
Discoverable.create(:name => 'Zeta III', :planet_type_id => 1, :discovered => false, :system_name => "Zeta Olympus", :position => 4)
Discoverable.create(:name => 'Solten', :planet_type_id => 3, :discovered => false, :system_name => "I Delta Kaising", :position => 1)
Discoverable.create(:name => 'Circinus', :planet_type_id => 1, :discovered => false, :system_name => "I Delta Kaising", :position => 2)
Discoverable.create(:name => 'Saos', :planet_type_id => 2, :discovered => false, :system_name => "Delta Ferol ", :position => 1)
Discoverable.create(:name => 'Ferrol', :planet_type_id => 5, :discovered => false, :system_name => "Delta Ferol ", :position => 2)
Discoverable.create(:name => 'Ferrol Uno', :planet_type_id => 1, :discovered => false, :system_name => "Delta Ferol ", :position => 3)
Discoverable.create(:name => 'Ferrol Dia', :planet_type_id => 1, :discovered => false, :system_name => "Delta Ferol ", :position => 4)
Discoverable.create(:name => 'Heimidal', :planet_type_id => 3, :discovered => false, :system_name => "Aqua Una", :position => 1)
Discoverable.create(:name => 'Cebotea', :planet_type_id => 1, :discovered => false, :system_name => "Aqua Una", :position => 2)
Discoverable.create(:name => 'Largamenia', :planet_type_id => 6, :discovered => false, :system_name => "Aqua Una", :position => 3)
Discoverable.create(:name => 'Revagon', :planet_type_id => 6, :discovered => false, :system_name => "Aqua Una", :position => 4)
Discoverable.create(:name => 'Unitera I', :planet_type_id => 2, :discovered => false, :system_name => "Corona Auatralis", :position => 1)
Discoverable.create(:name => 'Unitera II', :planet_type_id => 1, :discovered => false, :system_name => "Corona Auatralis", :position => 2)
Discoverable.create(:name => 'Unitera III', :planet_type_id => 4, :discovered => false, :system_name => "Corona Auatralis", :position => 3)
Discoverable.create(:name => 'Unitera IV', :planet_type_id => 3, :discovered => false, :system_name => "Corona Auatralis", :position => 4)
Discoverable.create(:name => 'Tleilax', :planet_type_id => 5, :discovered => false, :system_name => "Thalim", :position => 1)
Discoverable.create(:name => 'Washuun', :planet_type_id => 1, :discovered => false, :system_name => "Thalim", :position => 2)
Discoverable.create(:name => 'Yandin I', :planet_type_id => 2, :discovered => false, :system_name => "Yadin", :position => 1)
Discoverable.create(:name => 'Yandin II', :planet_type_id => 1, :discovered => false, :system_name => "Yadin", :position => 2)
Discoverable.create(:name => 'Yandin III', :planet_type_id => 1, :discovered => false, :system_name => "Yadin", :position => 3)
Discoverable.create(:name => 'Yandin IV', :planet_type_id => 3, :discovered => false, :system_name => "Yadin", :position => 4)
Discoverable.create(:name => 'Yandin V', :planet_type_id => 1, :discovered => false, :system_name => "Yadin", :position => 5)
Discoverable.create(:name => 'Yandin VI', :planet_type_id => 1, :discovered => false, :system_name => "Yadin", :position => 6)
Discoverable.create(:name => 'Yandin VII', :planet_type_id => 1, :discovered => false, :system_name => "Yadin", :position => 7)
Discoverable.create(:name => 'Yandin VIII', :planet_type_id => 1, :discovered => false, :system_name => "Yadin", :position => 8)
Discoverable.create(:name => 'Yandin IX', :planet_type_id => 6, :discovered => false, :system_name => "Yadin", :position => 9)
puts 'Discoverable done'

for house in House.all do
  i = 0
  2.times do
    i += 1
    planet = house.kolonizuj_planetu
    if i % 2 == 0
      planet.update_attribute(:available_to_all, true)
    end
    planet.save
  end

  Syselaad.create(
      :house_id => house.id,
      :subhouse_id => nil,
      :kind => 'N',
      :name => "Syselaad #{house.name}",
      :description => "Syselaad národu #{house.name}"
  )
end

Syselaad.create(
    :house_id => nil, :subhouse_id => nil, :kind => 'I', :name => "Imperiální Syselaad",
    :description => "Imperiální Syselaad")
Syselaad.create(
    :house_id => nil, :subhouse_id => nil, :kind => 'L', :name => "Landsraadský Syselaad",
    :description => "Landsraadský Syselaad")
Syselaad.create(
    :house_id => nil, :subhouse_id => nil, :kind => 'S', :name => "Systémový Syselaad",
    :description => "Systémový Syselaad")
Syselaad.create(
    :house_id => nil, :subhouse_id => nil, :kind => 'E', :name => "Mezinárodní Syselaad",
    :description => "Mezinárodní Syselaad")

for syselaad in Syselaad.all do
  syselaad.topics << Topic.create(:syselaad_id => syselaad.id, :user_id => 1, :name => 'Úvod',
                                  :last_poster_id => 1, :last_post_at => Time.now,)
end
for topic in Topic.all do
  topic.posts << Post.create(:topic_id => topic.id, :user_id => 1, :content => 'Vítejte!')
end

puts 'Vychozi planety objeveny'

doktor.jmenuj_spravcem

Prepocet.kompletni_prepocet
puts 'Prepocet spusten'

#doktor.odeber_spravcovstvi

puts 'KONEC SEED'

