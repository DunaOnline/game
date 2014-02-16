# encoding: utf-8
# == Schema Information
#
# Table name: planets
#
#  id               :integer          not null, primary key
#  name             :string(255)      not null
#  planet_type_id   :integer          not null
#  house_id         :integer
#  system_name      :string(255)
#  position         :integer
#  available_to_all :boolean          default(FALSE)
#  discovered_at    :date             default(Thu, 13 Dec 2012)
#  created_at       :datetime
#  updated_at       :datetime
#

class Planet < ActiveRecord::Base
  attr_accessible :name, :planet_type_id, :house_id, :available_to_all, :discovered_at, :system_name, :position

  belongs_to :house
  belongs_to :planet_type
  belongs_to :system, :primary_key => 'system_name', :foreign_key => 'system_name'
  has_many :orbits
  has_many :fields
  has_many :environment
  has_many :property, :through => :environment

  def vytvor_pole(user)
    Field.new(
        :planet_id => self.id,
        :name => self.name + ' - ' + user.nick + ' - ' + (self.vlastni_pole(user).count + 1).to_s,
        :user_id => user.id,
        :pos_x => user.house.id,
        :pos_y => user.id
    )
  end

  def oznaceni
    self.system.id.to_s + '.' + self.position.to_s
  end

  def arrakis?
    self.name == 'Arrakis'
  end

  def obsazenost
    max = self.max_poli
    aktualne = self.aktualne_obsazeno
    aktualne.to_s + '/' + max.to_s
  end

  def max_poli
    if self.planet_type.name == 'Domovská'
      max_poli = '-'
    else
      max_poli = self.planet_type.fields
    end
    max_poli
  end

  def aktualne_obsazeno
    self.fields.count
  end

  def background
    if self.name == 'Arrakis'
      'planety/arrakis.png'
    else
      case self.planet_type.name
        when 'Měsíc'
          'planety/1.png'
        when 'Typ Vesuvia'
          'planety/2.png'
        when 'Pengaranský typ'
          'planety/3.png'
        when 'Teranský typ'
          'planety/4.png'
        when 'Dyrovský typ'
          'planety/5.png'
        when 'Marganský typ'
          'planety/6.png'
        when 'Domovská'
          rod = self.house.name
          if rod == 'Titáni'
            'planety/dpl-Titani.png'
          elsif rod == 'Renegáti'
            'planety/dpl-renegati.png'
          else
            'planety/dpl-' + rod + '.png'
          end
        else
          'planety/neznama.png'
      end
    end
  end

  def vlastni_pole(user)
    self.fields.where(:user_id => user.id)
  end

  def zastoupeni_rodu
    self.fields.joins(:user, :house).includes(:house).count(:id, :group => 'houses.name')
    #self.fields.joins(:user, :house).count(:id, :group => :house)
  end

  def cena_noveho_lena_mel
    Vypocty.cena_noveho_lena_melanz(self)
  end

  def cena_noveho_lena_sol
    Vypocty.cena_noveho_lena_solary(self)
  end

  def vynos(user, ceho)
    vynos = 0.0
    self.fields.vlastnik(user).includes(:buildings).each { |field|
      vynos += field.vynos(ceho)
    }
    vynos
  end

  def osidlitelna?(user)
    (self.house == user.house || self.available_to_all)
  end

  def domovska?
    self.planet_type_id == PlanetType.find_by_name('Domovská').id
  end

  def self.kaitan
    @kaitan ||= Planet.find_by_name('Kaitan')
  end

  def melange_bonus
    if (vlastnik = User.spravce_arrakis)
      vlastnik.melange_bonus
    else
      0.0
    end
  end

  def zastoupene_rody
    a = []
    self.fields.includes(:user, :house).each do |field|
      if self == Arrakis.planeta || self == Planet.kaitan
        rod = House.imperium.name
      else
        rod = field.user.house.name
      end
      if rod
	      if a.assoc(rod) == nil
	        a << [rod, 1]
	      else
	        a.assoc(rod)[1] += 1
	      end
	    end
    end
    a.sort_by {|h| [ h[1],h[1] ]}
    a
  end

  def dominantni_rod
    a = self.zastoupene_rody
    if a[0]
      a[0]
    else
      ''
    end
  end

  def kapacita_kosmodromu(user)
	  n = 0
	  b = Building.where(:kind => 'K').first
	  self.fields.where(:user_id => user.id).each do |f|
		  n += f.estates.where(:building_id => b.id).first.number if f.estates.where(:building_id => b.id).first
	  end
	  n * Constant.kapacita_kosmodromu
  end

  def vyuzitie_kosmodromu(user)
    n = 0
	  self.orbits.where(:user_id => user.id).each do |o|
		   n += o.number
	  end
	  n
  end

  def celkova_populace(user)
    pop = 0.0
    for field in self.fields.vlastnik(user).includes(:resource) do
      pop += field.resource.population
    end
    pop
  end

  def celkovy_material(user)
    mat = 0.0
    for field in self.fields.vlastnik(user).includes(:resource) do
      mat += field.resource.material
    end
    mat
  end

  def celkovy_parts(user)
    parts = 0.0
    for field in self.fields.vlastnik(user).includes(:resource) do
      parts += field.resource.parts
    end
    parts
  end

  def pocet_poli_house(house)
	  u = 0
	  self.fields.each do |f|
		  u += 1 if f.user.house == house
	  end
	  u
  end

  def kapacita_parts(user)
    tovarna = Building.where(:kind => 'V').first

    pocet_tovaren = 0
    self.fields.vlastnik(user).each { |field|
      #leno_s_tovarnou = field.estates.where(:building_id => tovarna.id).first
      #pocet_tovaren += leno_s_tovarnou.number if leno_s_tovarnou
	    pocet_tovaren += field.kapacita_tovaren
    }
    pocet_tovaren
  end

  def self.nahodna_udalost
    enviro = Environment.all
    enviro.each do |envi|
      if envi.duration == 0
        envi.destroy
      else
        envi.update_attribute(:duration, envi.duration - 1)
      end
    end

    self.all.each do |planet|
      planet.udalost
    end
  end

  def udalost
    udalost = 0

    pocet_udalosti = Constant.pocet_udalosti.to_i
    pocet_udalosti.times do
      if udalost == rand(100/ Constant.pravdepodobnost)
        if Property.count > 0
          roll_property = rand(Property.nahodne.count) + 1
          property = Property.nahodne.find(roll_property)

          Environment.new(
              :planet_id => self.id,
              :property_id => property.id,
              :duration => property.duration
          ).save


          self.house.zapis_operaci("Mimoriadna udalost na planete #{self.name} : #{property.name}")

        end
      end
    end
  end

  def udalost_bonus(typ)
    enviro_bonus = 1
    if self.environment
      case typ
        when 'P'
          self.environment.each do |enviro|
            enviro_bonus += enviro.property.population_bonus * enviro.property.population_cost if enviro

          end
        when 'PL'
          self.environment.each do |enviro|
            enviro_bonus += enviro.property.pop_limit_bonus if enviro
          end
        when 'J'
          self.environment.each do |enviro|
            enviro_bonus += enviro.property.melange_bonus * enviro.property.melange_cost if enviro
          end
        when 'M'
          self.environment.each do |enviro|
            enviro_bonus += enviro.property.material_bonus * enviro.property.material_cost if enviro
          end
        when 'S'
          self.environment.each do |enviro|
            enviro_bonus += enviro.property.solar_bonus * enviro.property.solar_cost if enviro
          end
        when 'E'
          self.environment.each do |enviro|
            enviro_bonus += enviro.property.exp_bonus * enviro.property.exp_cost if enviro
          end
        else
          enviro_bonus = 1
      end
    end

    enviro_bonus != 1 ? enviro_bonus - 1 : 1


  end


  def jednotky(ship,user)
	  s = self.orbits.where(:ship_id => ship.id, :user_id => user.id).first
	  s
  end

  def attack(user)
	  c = 0
	  o = self.orbits.where(:user_id => user.id).all
	  o.each do |a|
		  c += a.ship.attack * a.number
	  end
	  c
  end

  def defence(user)
	  d = 0
	  o = self.orbits.where(:user_id => user.id).all
	  o.each do |a|
		  d += a.ship.defence * a.number
	  end
	  d
  end

  def salary(user)
	  sal = 0
	  o = self.orbits.where(:user_id => user.id).all
	  o.each do |a|
		  sal += a.ship.salary * a.number
	  end
	  sal.round(2)
  end

  def verbovat_ship(ships,user)
	  planet = self
	  a=b=total_material=total_price=total_population=total_pocet=number = 0
	  naverbovano = []
	  ships_msg = ""
	  ships.each do |ship|
		  pocet = ship[0][0].to_i.abs
		  total_pocet += pocet
		  lod = Ship.where(:name => ship[1][0]).first
		  total_material += lod.material * pocet
		  total_price += lod.solar * pocet
		  total_population += lod.population * pocet
	  end
	  material = planet.celkovy_material(user) >= total_material
	  price = user.solar >= total_price
	  population = planet.celkova_populace(user) >= total_population
	  miesto = true #planet.kapacita_kosmodromu(user) >= planet.vyuzitie_kosmodromu(user) + total_pocet
	  if miesto
		  if material && price && population
			  ships.each do |ship|
				  pocet = ship[0][0].to_i.abs
				  lod = Ship.where(:name => ship[1][0]).first
				  orbit = Orbit.where(:planet_id => self.id, :ship_id => lod.id).first
				  if orbit
					  orbit.update_attributes(:number => orbit.number + pocet)
				  else
					  orbit = Orbit.new(
							  :planet_id => planet.id,
							  :ship_id => lod.id,
							  :number => pocet,
					      :user_id => user.id
					  ).save
				  end
				  number += pocet
				  naverbovano << orbit
				  ships_msg += "#{pocet} ks #{lod.name}, "
			  end
			  oznamenie = "Bylo naverbovano #{ships_msg} za #{total_material} kg, #{total_price} solaru a #{total_population} populace."
			  user.zapis_operaci(oznamenie)
			  mat_helper = total_material
			  pop_helper = total_population
			  fields = planet.fields.where(:user_id => user)
			  begin
				  a = 0
				  if mat_helper <= fields[a].resource.material
					  fields[a].resource.update_attributes(:material => fields[a].resource.material - mat_helper)
					  mat_helper = 0
				  else
					  mat_helper -= fields[a].resource.material
					  fields[a].resource.update_attributes(:material => 0)
				  end
				  a += 1
			  end while mat_helper != 0

			  begin
				  b = 0
				  if pop_helper <= fields[b].resource.population
					  fields[b].resource.update_attributes(:population => fields[b].resource.population - pop_helper)
					  pop_helper = 0
				  else
					  pop_helper -= fields[b].resource.population
					  fields[b].resource.update_attributes(:population => 0)

				  end
				  b += 1
			  end while pop_helper != 0

			  user.update_attributes(:solar => user.solar - total_price)
		  else
			  oznamenie = "Chybi vam "
			  oznamenie += (total_material - planet.celkovy_material(user)).to_s + " kg materialu, " unless material
			  oznamenie += (total_price - user.solar).to_s + " solaru, " unless price
			  oznamenie += (total_population - planet.celkova_populace(user)).to_s + " pop, " unless population
			  oznamenie += "Zaridte suroviny."
			  naverbovano = false
		  end
	  else
		  oznamenie = "Nemate dostatek mista v kosmodromu."
	  end
	  return oznamenie, naverbovano
  end

  def sell_ship(ships,user)
	  planet = self
	  total_material = 0
	  total_price = 0
	  total_pocet = 0
	  total_population = 0
	  number = 0
	  oznamenie = ""
	  nemozno_prodat = []
	  ships.each do |ship|
		  pocet = ship[0][0].to_i.abs
		  total_pocet += pocet
		  lod = Ship.where(:name => ship[1][0]).first
		  if lod
			  if 0 < lod.vlastnim(user,planet) && lod.vlastnim(user,planet) >= pocet
				  total_material += (lod.material * pocet) / 2
				  total_price += (lod.solar * pocet) / 2
				  total_population += (lod.population * pocet) / 2
				  total_pocet += pocet
				  orbit = Orbit.where(:planet_id => planet.id, :ship_id => lod.id).first
				  orbit.update_attributes(:number => orbit.number - pocet)
				  fields = planet.fields.where(:user_id => user.id)
				  fields.first.resource.update_attributes(:material => fields.first.resource.material + ((lod.material * pocet) / 2).round(2), :population => fields.first.resource.population + ((lod.population * pocet) / 2).to_i)
				  user.update_attributes(:solar => user.solar + ((lod.solar * pocet) / 2).round(2))
				  fields.first.zapis_udalosti(user, "Bylo prodano #{pocet} ks #{lod.name} za #{(lod.material * pocet) / 2} kg, #{(lod.solar * pocet) / 2} solaru a #{(lod.population * pocet) / 2} populacie.")
				  nemozno_prodat << orbit
			  else
				  nemozno_prodat = nil
			  end
		  end
	  end
	  if !nemozno_prodat
		  oznamenie = "Tolik vyrobku nemozno prodat."
	  else
		  oznamenie = "Bylo prodano #{total_pocet} vyrobku, prodejem sme ziskali #{total_material} kg materialu, #{total_price} solaru a #{total_population} populacie."
	  end
	  return oznamenie, nemozno_prodat
  end


  def move_ships(target, ships, user)
	  success = false
	  kapacita = self.kapacita_kosmodromu(user)
	  flag = false
	  total_ships = 0
	  ships_helper = []
	  ships.each do |par|
		  pocet = par[0][0].to_i.abs
		  ship = Ship.where(:name => par[1][0]).first
		  total_ships += pocet
		  source_orbit = self.orbits.where(:ship_id => ship.id, :user_id => user.id).first
		  flag = source_orbit.check_ships_move_avail(user, pocet)
		  if flag != true
			  break
		  end
		  ships_helper << [pocet, ship]
	  end
	  if self != target
		  if total_ships + target.vyuzitie_kosmodromu(user) <= kapacita
			  if flag == true
				  ships_helper.each do |i|
					  pocet = i[0]
					  jednotka = i[1]
					  source_orbit = self.orbits.where(:ship_id => jednotka.id, :user_id => user.id).first
					  target_orbit = target.orbits.where(:ship_id => jednotka.id, :user_id => user.id).first
					  if source_orbit
						  unless target_orbit
							  target_orbit = Orbit.new(
									  :ship_id => jednotka.id,
									  :planet_id => target.id,
									  :number => 0,
							      :user_id => user.id)
						  end
						  success = true
						  source_orbit.update_attribute(:number, source_orbit.number - pocet)
						  target_orbit.update_attribute(:number, target_orbit.number + pocet)
						  user.zapis_operaci(user, "Bylo presunuto #{pocet} ks #{jednotka.name} z #{self.name} na #{target.name} leno, Za presun zaplaceno #{Constant.presun_vyrobku * pocet} solaru.")
					  end
				  end
				  msg = "Bylo presunuto #{total_ships} ks z planety #{self.name} na planetu #{target.name}, Za presun zaplaceno #{Constant.ship_movement_cost * total_ships} solaru."
			  else
				  msg = flag
			  end
		  else
			  msg = "Nemate dostatek mista na prichozi planete."
		  end
	  else
		  msg = "Nemuzes presouvat medzi stejnou planetou."
	  end
	  return success, msg
  end

  scope :domovska, lambda { |user| where(:house_id => user.house.id, :planet_type_id => PlanetType.find_by_name('Domovská')) }
  scope :domovska_rodu, lambda { |house| where(:house_id => house.id, :planet_type_id => PlanetType.find_by_name('Domovská')) }
  scope :domovske, where(:planet_type_id => PlanetType.find_by_name('Domovská'))
  scope :osidlitelna, where(:available_to_all => true)
  scope :objevene, where('available_to_all = ? AND planet_type_id <> ? AND name <> ?', false, PlanetType.find_by_name('Domovská').try(:id), 'Arrakis')
  #scope :objevena, where(:available_to_all => false, :planet_type_id => PlanetType.find_by_name("Domovská"))
  scope :viditelna, lambda { |house| where(:house_id => house.id, :available_to_all => false) }

end
