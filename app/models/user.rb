# encoding: utf-8
# == Schema Information
#
# Table name: users
#
#  id            :integer          not null, primary key
#  username      :string(255)      not null
#  nick          :string(255)      not null
#  email         :string(255)
#  password_hash :string(255)
#  password_salt :string(255)
#  house_id      :integer          not null
#  subhouse_id   :integer
#  solar         :decimal(12, 4)   default(0.0)
#  melange       :decimal(12, 4)   default(0.0)
#  exp           :decimal(12, 4)   default(0.0)
#  leader        :boolean          default(FALSE)
#  mentat        :boolean          default(FALSE)
#  army_mentat   :boolean          default(FALSE)
#  diplomat      :boolean          default(FALSE)
#  general       :boolean          default(FALSE)
#  vicegeneral   :boolean          default(FALSE)
#  landsraad     :boolean          default(FALSE)
#  arrakis       :boolean          default(FALSE)
#  emperor       :boolean          default(FALSE)
#  regent        :boolean          default(FALSE)
#  court         :boolean          default(FALSE)
#  vezir         :boolean          default(FALSE)
#  admin         :boolean          default(FALSE)
#  created_at    :datetime
#  updated_at    :datetime
#  influence     :decimal(, )
#  web           :string(255)      default(" ")
#  icq           :string(255)      default(" ")
#  gtalk         :string(255)      default(" ")
#  skype         :string(255)      default(" ")
#  facebook      :string(255)      default(" ")
#  presentation  :text             default(" ")
#  active        :boolean          default(TRUE)
#

class User < ActiveRecord::Base
  # new columns need to be added here to be writable through mass assignment
  attr_accessible :username, :email, :password, :password_confirmation, :house_id, :subhouse_id, :solar, :melange
  attr_accessible :exp, :leader, :mentat, :army_mentat, :diplomat, :general, :vicegeneral, :landsraad, :arrakis, :ziadost_house, :ziadost_subhouse
  attr_accessible :emperor, :regent, :court, :vezir, :admin, :nick, :influence
  attr_accessible :web, :icq, :gtalk, :skype, :facebook, :presentation, :active

  attr_accessor :password
  before_save :prepare_password

  # after_save :napln_suroviny

  belongs_to :house
  belongs_to :subhouse
  has_many :fields
  has_many :resources, :through => :fields
  has_many :votes, :foreign_key => 'elective'

  has_many :operations

  has_many :eods

  has_many :productions

  has_many :polls
  has_many :laws, :through => :polls

  has_many :researches
  has_many :technologies, :through => :researches

  has_many :conversations, :foreign_key => 'receiver'
  has_many :messages

  validates :username, :presence => true, :uniqueness => true
  validates :password, :presence => true, :on => :create
  validates :nick, :presence => true, :uniqueness => true
  validates_length_of :nick, :minimum => 3, :maximum => 19
  validates_confirmation_of :password
  validates_uniqueness_of :email, :allow_blank => true
  validates_format_of :username, :with => /^[-\w\._@]+$/i, :allow_blank => true, :message => "should only contain letters, numbers, or .-_@"
  validates_format_of :email, :with => /^[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}$/i

  validates_length_of :password, :minimum => 4, :allow_blank => true
  # login can be either username or email address
  def self.authenticate(login, pass)
    user = User.find_by_username(login) || User.find_by_email(login)
    return user if user && user.password_hash == user.encrypt_password(pass)
  end

  def encrypt_password(pass)
    BCrypt::Engine.hash_secret(pass, password_salt)
  end

  def change_password(pass)
    update_attribute "password_hash", encrypt_password(pass)
    true
  end

  def najdi_planety
    planets = []
    for field in self.fields do
      planets << field.planet unless planets.include?(field.planet)
    end
    planets
  end

  def najdi_hodnosti
    hodnosti = []
    hodnosti << "Emperor" if self.emperor
    hodnosti << "Regent" if self.regent
    hodnosti << "Clen dvora" if self.court
    hodnosti << "Vezir" if self.vezir
    hodnosti << "Leader" if self.leader
    hodnosti << "Mentat" if self.mentat
    hodnosti << "Vojensky Mentat" if self.army_mentat
    hodnosti << "Diplomat" if self.diplomat
    hodnosti << "General" if self.general
    hodnosti << "ViceGeneral" if self.vicegeneral
    hodnosti << "Poslanec" if self.landsraad
    hodnosti << "Spravce Arrakis" if self.arrakis
    hodnosti << "ADMIN" if self.admin
    hodnosti
  end

  def hlasuj(koho, typ)
    if vote = Vote.where(:house_id => self.house.id, :elector => self.id, :typ => typ).first
      self.zapis_operaci("Ve volbe na pozici #{typ} jsi zmenil hlas z #{User.find(vote.elective).nick} na #{User.find(koho).nick}.")
      vote.update_attribute(:elective, koho.id)
    else
      self.zapis_operaci("Ve volbe na pozici #{typ} jsi hlasoval pro #{User.find(koho).nick}.")
      Vote.new(:house_id => self.house.id, :elector => self.id, :elective => koho.id, :typ => typ).save
    end
  end

  def odhlasuj(typ)
	  vote = Vote.where(:house_id => self.house.id, :elector => self.id, :typ => typ).first
	  vote.delete if vote
  end

  def odhlasuj_gene
	  self.subhouse.users.each do |u|
		  unless self == u
		    vote = Vote.where(:house_id => self.house.id, :elector => u.id, :typ => "general").first
			  vote.elective == self.id ? vote.delete : {}
			end
	  end
  end

  def koho_jsem_volil(typ)
    voleno = self.house.votes.where(:typ => typ, :elector => self.id).first
    if voleno
      User.find(voleno.elective).nick
    else
      'nikdo'
    end
  end

  def vol_imperatora(koho)
    imp = House.imperium
    typ = 'imperator'
    if vote = Vote.where(:house_id => imp.id, :elector => self.id, :typ => typ).first
      #self.zapis_operaci("Ve volbe na pozici Imperatora jsi zmenil hlas z #{User.find(vote.elective).nick} na #{User.find(koho).nick}.")
      vote.update_attribute(:elective, koho.id)
    else
      #self.zapis_operaci("Ve volbe na pozici Imperatora jsi hlasoval pro #{User.find(koho).nick}.")
      Vote.new(:house_id => imp.id, :elector => self.id, :elective => koho.id, :typ => typ).save
    end
  end

  def koho_jsem_volil_imperatorem
    voleno = House.imperium.votes.where(:typ => 'imperator', :elector => self.id).first
    if voleno
      User.find(voleno.elective).nick
    else
      'nikdo'
    end
  end

  def napln_suroviny
    # asi rozdelime pak podle rodu
    self.update_attributes(:solar => 1600.0, :melange => 2.0, :exp => 0)
    self.fields.first.resource.update_attributes(:population => 10000, :material => 1700.0, :parts => 0)
  end

  def celkovy_material
    mat = 0.0
    for field in self.fields.includes(:resource) do
      mat += field.resource.material
    end
    mat
  end

  def celkova_populace
    pop = 0
    for field in self.fields.includes(:resource) do
      pop += field.resource.population
    end
    pop
  end

  def celkovy_parts
    parts = 0
    for field in self.fields.includes(:resource) do
      parts += field.resource.parts
    end
    parts
  end

  def osidlene_planety
    plt_id = []
    for field in self.fields do
      plt_id << field.planet unless plt_id.include?(field.planet)
    end
    plt_id.sort!
  end

  def dovolene_budovy(kind)
    # TODO dovolene budovy podle tech levelu
    technology = Technology.where(:bonus_type => kind).first

    if technology

      lvl = technology.vylepseno(self)

      case lvl
        when 0..6
          Building.where(:kind => kind, :level => [1]).all
        when 7..13
          Building.where(:kind => kind, :level => [1, 2]).all
        when 14..17
          Building.where(:kind => kind).all
      end
    else
      Building.where(:kind => kind, :level => [1]).all(:group => "name")
    end

  end

  def stat_se(cim) # cim = presne nazev attributu
                   #self.zapis_operaci("Od ted jsem #{cim}.")
    self.update_attribute(cim, true)
  end

  def prestat_byt(cim) # cim = presne nazev attributu
                       #self.zapis_operaci("Uz dale nejsem #{cim}.")
    self.update_attribute(cim, false)
  end

  def melange_bonus
    # TODO bonus z vyzkumu
    1.0
  end

  def self.spravce_arrakis
    User.find_by_arrakis(true)
  end

  def self.imperator
    User.find_by_emperor(true)
  end

  def self.regenti
    User.find_all_by_regent(true)
  end

  def jmenuj_spravcem
    self.stat_se('arrakis')
    Global.prepni('bezvladi_arrakis', 2, nil)
  end

  def odeber_spravcovstvi
    self.prestat_byt('arrakis')
    Global.prepni('bezvladi_arrakis', 2, 3.days.since)
  end

  def menuj_vice
    self.update_attribute(:vicegeneral, true)
  end

  def zober_vice
	  self.update_attribute(:vicegeneral, false)
  end

  def zapis_operaci(content, kind = "U")
    self.operations << Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now)
  end

  def vliv
    vl = self.politicke_postaveni * (self.fields.count + (self.celkova_populace / 100000.0))
    return vl.round(4)
  end

  def domovske_leno
    self.fields.where(:planet_id => Planet.domovska_rodu(self.house)).first
  end

  def tech_bonus(bonus_type)
    technologie = Technology.where(:bonus_type => bonus_type).first
    vyskumane_tech = self.researches.where('technology_id' => technologie.id).first if technologie
    if vyskumane_tech
      vyskumane_tech.lvl * technologie.bonus + 1
    else
      1
    end
  end

  def goods_to_buyer(typ, amount)

    case typ
      when "M"
        self.domovske_leno.resource.update_attribute(:material, self.domovske_leno.resource.material + amount)
      when "V"
        self.domovske_leno.resource.update_attribute(:parts, self.domovske_leno.resource.parts + amount)
      when "J"
        self.update_attribute(:melange, self.melange + amount)
      when "E"
        self.update_attribute(:exp, self.exp + amount)
      else
        production = self.domovske_leno.resource.productions.where(:product_id => typ).first
        production.update_attribute(:amount, production.amount + amount)
    end
  end

  def miesto_v_tovarni?(amount)
    self.domovske_leno.vyuzitie_tovaren + amount.to_i <= self.domovske_leno.kapacita_tovaren
  end

  def for_sale
    na_prodej = []
    vyrobky = self.domovske_leno.resource.productions.where("amount > ?", 0)
    vyrobky.each do |vyrobok|
      nazov = Product.find(vyrobok.product_id).title
      na_prodej << [nazov + " " + vyrobok.amount.to_s + "ks", vyrobok.product_id]

    end
    na_prodej << ['Materiál', 'M'] if self.domovske_leno.resource.material > 0
    na_prodej << ['Melanž', 'J'] if self.melange > 0
    na_prodej << ['Expy', 'E'] if self.exp > 0
    na_prodej << ['Vyrobky', 'V'] if self.domovske_leno.resource.parts > 0
    na_prodej
  end

  def resourcy_s_tovarny
    tovarna = Building.where(:kind => "V").first
    self.fields.includes(:estates).where("estates.building_id = ?", tovarna.id,)
  end

  def factories_options
    fields = self.resourcy_s_tovarny
    resourcy = []

    fields.each do |field|
      if field.resource.parts
        resourcy << [field.name + ' - ' + field.resource.parts.to_s + ' ks', field.id.to_s]
      else
        resourcy << [field.name + ' - ' + field.resource.parts.to_s + '0 ks', field.id.to_s]
      end
      #@artists = genre.artists.map{|a| [a.name, a.id]}.insert(0, "Select an Artist")
    end
    resourcy
  end


  def zobraz_udalost
    msg_leno = []
    msg_pla = []
    self.fields.each do |field|
      field.influence.each do |influence|
        if influence && influence.effect.typ != "M"
          msg_leno << ["//**Udalost na lenu #{field.name} : #{influence.effect.name}**//", influence]
        end
      end
    end

    self.fields.each do |field|
      field.planet.environment.each do |environment|
        if environment
          msg_pla << ["//**Udalost na planete #{field.planet.name} : #{environment.property.name}**//", environment]
        end
      end

    end
    return msg_leno, msg_pla
  end

  def opustit_narod
    narod = self.house
    field = self.domovske_leno
    field.update_attribute(:planet_id, Planet.domovska_rodu(House.renegat).first.id)
    self.update_attribute(:house_id, House.renegat.id)
    self.zapis_operaci("Opustili jste narod #{narod.name}")
    Influence.new(
        :field_id => field.id,
        :effect_id => Effect.find_by_typ("M").id,
        :duration => 100,
        :started_at => Date.today
    ).save
	  self.odhlasuj("leader")
    self.odhlasuj_gene
	  self.reset_hodnosti
  end

  def reset_hodnosti
	  self.update_attributes(:vicegeneral => false, :general => false, :mentat => false, :army_mentat => false, :leader => false)
  end

  def opustit_mr
    subhouse = self.subhouse
    if self.general
	     self.odhlasuj_gene
    end
    self.update_attributes(:subhouse_id => nil, :vicegeneral => false, :general => false)
    if subhouse.users.count == 0
      subhouse.house.update_attributes(:solar => subhouse.house.solar + subhouse.solar, :material => subhouse.house.material + subhouse.material,
                                       :melange => subhouse.house.melange + subhouse.melange, :exp => subhouse.house.exp + subhouse.exp, :parts => subhouse.house.parts + subhouse.parts)
      self.house.zapis_operaci("Byl rozpusten malorod #{subhouse.name} do narodnych skladu pribudlo #{subhouse.solar} solaru, #{subhouse.material} materialu, #{subhouse.melange} mg,
                                #{subhouse.exp} expu a #{subhouse.parts} dilu")
      subhouse.delete
    end
    self.odhlasuj("general")

  end

  def podat_ziadost(house_id)
    house = House.find(house_id)
    infl = self.domovske_leno.influence.where(:effect_id => Effect.find_by_typ("M").id).first
    if infl

      if  infl.started_at + Constant.dni_v_renegatoch.days <= Date.today

        self.update_attributes(:house_id => House.renegat.id, :ziadost_house => house_id)
        self.zapis_operaci("Podali sme zadosti o prijeti do naroda #{house.name}")
        return "Podali sme zadosti o prijeti do naroda #{house.name}"
      else
        return "Musite pockat este #{((infl.started_at + Constant.dni_v_renegatoch.days) - Date.today ).to_i } dnu. "
      end
    else
      return "Nieste renegat"
    end

  end

  def prijat_do_naroda(house)
    if self.house == House.renegat
      field = self.domovske_leno
      field.update_attribute(:planet_id, Planet.domovska_rodu(house).first.id)
      if o = Influence.where(:field_id => field, :effect_id => Effect.find_by_typ("M")).first
        o.destroy
      end
      self.update_attributes(:house_id => house.id, :ziadost_house => nil)
      self.zapis_operaci("Byl jsi přijat do národa #{house.name}. Opustil jsi renegáty.")
      house.zapis_operaci("Do národa byl přijat hráč #{self.nick}.")
      return true
    end
    return false
  end

  def prijat_do_mr(mr)

    if self.subhouse == nil && mr.users.count <= Constant.max_u_mr
      self.update_attributes(:subhouse_id => mr.id, :ziadost_subhouse => nil)
      self.zapis_operaci("Byl jste přijat do malorodu #{mr.name}.")
      mr.zapis_operaci("Hráč #{self.nick} byl přijat do malorodu.")
      return true
    else
      return false
    end
  end

  def neprocteno_sprav
    self.conversations.where(:opened => nil).count
  end

  def politicke_postaveni
    # Imperátor > Mistodržící > Regent > Vůdce > Poslanec > Mentat > Vojenský mentat > Diplomat > Guvernér
    pp = 1
    if self.emperor?
      pp += 0.05
    else
      if self.arrakis?
        pp += 0.05
      else
        if self.regent?
          pp += 0.02
        else
          if self.leader?
            pp += 0.02
          else
            if self.landsraad?
              pp += 0.02
            else
              if self.court? || self.vezir?
                pp += 0.02
              else
                if self.mentat? || self.army_mentat? || self.diplomat?
                  pp += 0.01
                else
                  if self.general? || self.vicegeneral?
                    pp += 0.01
                  else

                  end
                end
              end
            end
          end
        end
      end
    end

    return pp
  end

  def preprava_cost(amount, typ)
    if typ == "leno"
      House.imperium.update_attribute(:solar, House.imperium.solar + (amount * Constant.presun_leno))
      self.update_attribute(:solar, self.solar - (amount * Constant.presun_leno))
      return true
    elsif  typ == "planeta"
      House.imperium.update_attribute(:solar, House.imperium.solar + (amount * Constant.presun_planeta))
      self.update_attribute(:solar, self.solar - (amount * Constant.presun_planeta))
      return true
    else
      return false
    end
  end

  def move_to_house(suroviny)
    msg = ""
    presun = false
    suroviny.each do |sur|
      if sur > 0
        presun = true
      end
    end
    if presun
      h_solar = suroviny[0]
      h_melange = suroviny[1]
      h_exp = suroviny[2]
      h_material = suroviny[3]
      h_parts = suroviny[4]
      sprava, flag = self.check_availability(h_solar, h_material, h_melange, h_exp, h_parts)
      if flag == true
        house = self.house
        house.update_attributes(:solar => house.solar + h_solar, :material => house.material + h_material, :melange => house.melange + h_melange, :exp => house.exp + h_exp, :parts => house.parts + h_parts)
        self.update_attributes(:solar => self.solar - h_solar, :melange => self.melange - h_melange, :exp => self.exp - h_exp)
        self.domovske_leno.resource.update_attributes(:material => self.domovske_leno.resource.material - h_material, :parts => self.domovske_leno.resource.parts - h_parts)
        msg += "Posláno narodu #{house.name} #{h_solar} solaru, #{h_material} kg, #{h_melange} mg, #{h_exp} exp, #{h_parts} dilu od hraca #{self.nick}"
        self.zapis_operaci(msg)
	      house.zapis_operaci(msg)
      else
        msg += sprava
      end
    end
    return msg, flag
  end

  def move_to_mr(suroviny)
    msg = ""
    presun = false
    suroviny.each do |n_sur|
      if n_sur > 0
        presun = true
      end
    end
    if presun
      mr_solar = suroviny[0]
      mr_melange = suroviny[1]
      mr_exp = suroviny[2]
      mr_material = suroviny[3]
      mr_parts = suroviny[4]
      sprava, flag = self.check_availability(mr_solar, mr_material, mr_melange, mr_exp, mr_parts)
      if flag == true
        mr = self.subhouse
        mr.update_attributes(:solar => mr.solar + mr_solar, :melange => mr.melange + mr_melange, :exp => mr.exp + mr_exp, :parts => mr.parts + mr_parts, :material => mr.material + mr_material)
        self.update_attributes(:solar => self.solar - mr_solar, :melange => self.melange - mr_melange, :exp => self.exp - mr_exp)
        self.domovske_leno.resource.update_attributes(:material => self.domovske_leno.resource.material - mr_material, :parts => self.domovske_leno.resource.parts - mr_parts)
        msg ="Posláno malorodu #{mr.name} #{mr_solar} solaru, #{mr_material} kg, #{mr_melange} mg, #{mr_exp} exp, #{mr_parts} dilu od hraca #{self.nick}"
        self.zapis_operaci(msg)
	      mr.zapis_operaci(msg)
      else
        msg += sprava
      end
    end
    return msg, flag
  end

  def sell_goods(market)
    msg = ""
    flag = false
    amount = market.amount
    case market.area
      when "M"
        if amount > self.domovske_leno.resource.material
          msg += market.nemate_dost
        else
          self.domovske_leno.resource.update_attribute(:material, self.domovske_leno.resource.material - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "P"
        if amount > self.domovske_leno.resource.population
          msg += market.nemate_dost
        else
          self.domovske_leno.resource.update_attribute(:population, self.domovske_leno.resource.population - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "V"
        if amount > self.domovske_leno.resource.parts
          msg += market.nemate_dost
        else
          self.domovske_leno.resource.update_attribute(:parts, self.domovske_leno.resource.parts - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "J"
        if amount > self.melange
          msg += market.nemate_dost
        else
          self.update_attribute(:melange, self.melange - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      when "E"
        if amount > self.exp
          msg += market.nemate_dost
        else
          self.update_attribute(:exp, self.exp - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end
      else
        production = self.domovske_leno.resource.productions.where(:product_id => market.area).first
        if amount > production.amount
          msg += market.nemate_dost
        else
          production.update_attribute(:amount, production.amount - amount)
          self.bylo_poslano_trh(market, amount)
          flag = true
        end

    end
    return flag, msg
  end

  def bylo_poslano_trh(market, amount)
    market.zapis_obchodu(self.id, "Bylo poslano na trh zbozi #{market.show_area}, #{amount} ks, za #{market.price * amount} solaru")
  end

  def posli_suroviny(h, mr)
    msg = ""
    sprava, flag = self.move_to_house(h)
    sprava1, flag1 = self.move_to_mr(mr)
    msg += sprava if sprava
    msg += sprava1 if sprava1

    return msg, flag || flag1
  end

  def check_availability(sol, mat, mel, exp, par)
    msg = ""
    flag = false
    bsol = self.solar >= sol
    bmat = self.domovske_leno.resource.material >= mat
    bmel = self.melange >= mel
    bexp = self.exp >= exp
    bpar = self.domovske_leno.resource.parts >= par
    if bsol && bmat && bmel && bexp && bpar
      flag = true
    else
      flag = false
      msg += "Chybi vam "
      msg += "#{sol - self.solar} solaru" unless bsol
      msg += "#{mat - self.domovske_leno.resource.material} materialu" unless bmat
      msg += "#{mel - self.melange} materialu" unless bmel
      msg += "#{exp - self.exp} exp" unless bexp
      msg += "#{par - self.domovske_leno.resource.parts} dilu" unless bpar
    end
    return msg, flag
  end

  def move_products(production, amount)
    flag = false
    msg = ""
    if amount > 0
      if production.amount >= amount
        production.update_attribute(:amount, production.amount - amount)
        kam = self.house.productions.where(:product_id => production.product_id).first
        if kam
          flag = true
          kam.update_attribute(:amount, kam.amount + amount)
        else
          Production.new(
              :house_id => self.house.id,
              :product_id => production.product_id,
              :amount => amount
          ).save
          flag = true
        end
      else
        msg = "Nemozete presunut vyrobky"
      end
    else
      msg = "Musite zadat pocet vyrobkov na presun"
    end
    return msg, flag
  end

  def barvicky

		  if self.emperor?
			  "Emperor"
		  elsif self.regent?
			  "Regent"
		  elsif self.arrakis?
			  "Drzitel Pololena"
		  elsif self.admin?
			  "Admin"
		  elsif self.leader?
			  "Leader"
		  elsif self.vezir?
			   "Vezir"
		  elsif self.landsraad?
			   "Poslanec"
		  elsif self.mentat?
			  "Mentat"
		  elsif self.army_mentat?
			  "Army_mentat"
		  elsif self.diplomat?
			   "Diplomat"
		  elsif self.court?
			  "Court"
		  elsif self.general?
			  "General"

	  end
  end


  private

  def prepare_password
    unless password.blank?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = encrypt_password(password)
    end
  end

  scope :without_user, lambda { |user| user ? {:conditions => ["id != ?", user.id]} : {} }
  scope :ziadost, lambda { |house| where("ziadost_house = ?", house) }
  scope :malorod, lambda { |mr| where("ziadost_subhouse = ?", mr) }
  scope :dvorane, where(:court => true)
  scope :veziri, where(:vezir => true)
  scope :poslanci, where(:landsraad => true)
  scope :general, where(:general => true)
  scope :vicegeneral, where(:vicegeneral => true)
  scope :players, where(:admin => false)
  scope :by_nick, order(:nick)
end
