# encoding: utf-8
# == Schema Information
#
# Table name: houses
#
#  id              :integer          not null, primary key
#  name            :string(255)      not null
#  leader          :string(255)
#  solar           :decimal(12, 4)   default(0.0)
#  melange         :decimal(12, 4)   default(0.0)
#  material        :decimal(12, 4)   default(0.0)
#  exp             :decimal(12, 4)   default(0.0)
#  playable        :boolean          default(TRUE)
#  melange_percent :decimal(12, 4)   default(0.0)
#  created_at      :datetime
#  updated_at      :datetime
#  influence       :decimal(, )
#

class House < ActiveRecord::Base
  attr_accessible :name, :leader, :solar, :melange, :material, :exp, :playable, :melange_percent
  attr_accessible :influence

  has_many :researches
  has_many :users
  has_many :fields, :through => :users
  has_many :planets
  has_many :votes
  has_many :operations
  has_many :syselaads

  def poradi_hlasu(typ, pocet = 5)
    hlasy = secti_hlasy(typ, pocet)
    poradi = []
    hlasy.each do |key, val|
      poradi << [User.find(key), val]
    end
    return poradi
  end

  def secti_hlasy(typ, pocet)
    self.votes.where(:typ => typ).group(:elective).limit(pocet).order('count_id desc, created_at').count('id')
  end

  def kdo_je_vitez(typ)
    vitez = secti_hlasy(typ, 1)
    vitez.each_key { |key| return User.find(key) }
  end

  def vudce
    self.users.where(:leader => true).first
  end

  def mentate
    self.users.where(:mentat => true).order(:nick).all
  end

  def army_mentate
    self.users.where(:army_mentat => true).order(:nick).all
  end

  def diplomate
    self.users.where(:diplomat => true).order(:nick).all
  end

  def generalove
    self.users.where(:general => true).order(:nick).all
  end

  def poslanci
    self.users.where(:landsraad => true).order(:nick).all
  end

  def vyskumane_narodni_tech(bonus_type)
    technologie = Technology.where(:bonus_type => bonus_type).first
    vyskumane_tech = self.researches.where(:technology_id => technologie.id).first if technologie
    if vyskumane_tech
      vyskumane_tech.lvl * technologie.house_bonus
    else
      0
    end
  end

  def celkova_populace
    pop = 0.0
    for usr in self.users do
      for field in usr.fields do
        pop += field.resource.population
      end
    end
    pop
  end

  def pocet_planet
    self.planets.count
  end

  def kolonizuj_planetu
    disc = Discoverable.kolonizovatelna.order("RANDOM()").first
    typ = disc.planet_type_id
    typ += (rand(5) - 2)
    typ = 1 if typ < 1
    typ = 8 if typ > 8
    planet = Planet.new(
        :name => disc.name,
        :system_name => disc.system_name,
        :position => disc.position,
        :planet_type_id => typ,
        :house_id => self.id,
        :available_to_all => false,
        :discovered_at => Date.today)
    disc.update_attribute(:discovered, true)
    self.zapis_operaci("Kolonizovana planeta #{planet.name} v systemu #{planet.system_name} (#{planet.system.id}).")
    planet
  end

  def eod_zapis_vudce(order, vudce)
    for user in self.users.includes(:eods) do
      for eod in user.eods.where(:date => Date.today, :leader => nil, :order => order).all do
        eod.update_attribute(:leader, vudce.id)
      end
    end
  end

  def self.imperium
    @imperium ||= House.find_by_name('Impérium')
  end

  def zapis_operaci(content, kind = "N")
    self.operations << Operation.new(:kind => kind, :content => content, :date => Date.today, :time => Time.now)
  end

  def vliv
    self.users.sum(:influence)
  end

  def pomer_vlivu
    celk_vl = House.imperium.influence
    vl = self.influence
    if celk_vl == 0
      0.0
    else
      vl / celk_vl
    end
  end

  def pocet_poslancu
    pomer = self.pomer_vlivu
    poslancu = Landsraad.pocet_poslancu * pomer
    zaokrouhlene = poslancu.round(0)
    if poslancu < zaokrouhlene
      zaokrouhlene -= 1
    else
      zaokrouhlene += 1
    end

    return zaokrouhlene
  end

  scope :playable, where(:playable => true)
end
