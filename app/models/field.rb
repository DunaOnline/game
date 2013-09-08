# encoding: utf-8
# == Schema Information
#
# Table name: fields
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  planet_id  :integer          not null
#  name       :string(255)      not null
#  pos_x      :decimal(, )      default(0.0)
#  pos_y      :decimal(, )      default(0.0)
#  created_at :datetime
#  updated_at :datetime
#

class Field < ActiveRecord::Base
  attr_accessible :user_id, :planet_id, :name, :pos_x, :pos_y

  belongs_to :user
  has_one :house, :through => :user
  belongs_to :planet
  has_one :resource
  has_many :estates
  has_many :buildings, :through => :estates

  after_save :vytvor_resource

  def vytvor_resource
    # nejak mi nefunguje after_create tak jak ma
    unless self.resource
      Resource.new(:user_id => self.user_id, :field_id => self.id, :population => 100000, :material => 2000.0, :parts => 0).save
    end
  end

  def souradnice
    self.pos_x.to_i.to_s + "." + self.pos_y.to_i.to_s
  end

  def oznaceni
    self.planet.id.to_s + "." + self.id.to_s + "." + self.souradnice
  end

  def drzitel(user)
    if user.admin?
      true
    else
      self.user == user
    end
  end

  def vynos(ceho)
    vynos = 0.0
    case ceho
      when 'solar'
        kind = 'S'
      when 'material'
        kind = 'M'
      when 'exp'
        kind = 'E'
      when 'population'
        kind = 'L'
      when 'melange'
        kind = 'J'
	    when 'parts'
		    kind = 'V'
    end
    pop = self.resource.population
    for building in self.buildings.where('kind LIKE ?', '%'+kind+'%') do
      pocet = self.estates.where(:building_id => building).first.number
      attr = 'vynos_' + ceho
      if pop > building.nutna_pop
        vynos += building.send(attr) * pocet
      else
        vynos += building.send(attr) * pocet * Constant.vynos_bez_pop
      end
    end
    vynos
  end

  def postaveno(building)
    estate = self.estates.where(:building_id => building).first
    if estate
      estate.number
    else
      0
    end
  end

  def zastavba
    max = self.max_budov
    aktualne = self.aktualne_zastaveno
    aktualne.to_s + "/" + max.to_s
  end

  def max_budov
    Constant.budov_na_leno.to_i
  end

  def aktualne_zastaveno
    self.estates.sum(:number)
  end

  def volne_misto
    self.max_budov - self.aktualne_zastaveno
  end

  def postav(budova, pocet)
    estate = self.estates.where(:building_id => budova).first
    if estate
      estate.update_attribute(:number, estate.number + pocet)
    else
      Estate.new(
          :field_id => self.id,
          :building_id => budova.id,
          :number => pocet
      ).save
    end
  end




  def vyuzitie_tovaren
	  vyrobky = self.resource.productions
	  pocet_vyrobkov = 0
	  vyrobky.each do |vyrobok|
		  pocet_vyrobkov += vyrobok.amount
	  end

	  pocet_vyrobkov
	  #.to_s + "/" + self.kapacita_tovaren.to_s

  end

  def kapacita_tovaren
	  tovarna = Building.where(:kind => "V").first
	  kapacita = self.estates.where(:building_id => tovarna.id).first
	  kapacita = (kapacita.number * Constant.kapacita_tovaren).to_i
  end

  def move_products(co,target,amount,user)
	  vyrobok = Product.find(co)
	  source_production = self.resource.productions.where(:product_id => vyrobok.id).first
	  target_production = target.resource.productions.where(:product_id => vyrobok.id).first

	  unless target_production
		  target_production = Production.new(
				  :resource_id => target.resource.id,
				  :user_id => user.id,
				  :product_id => vyrobok.id,
				  :amount => 0
		  )
	  end

	  case str = source_production.check_availability(amount,target,target_production)
		  when true
			  source_production.update_attribute(:amount, source_production.amount - amount)
			  target_production.update_attribute(:amount, target_production.amount + amount)

		  else
			  message = str

	  end
  end

  def move_resource(to, what, amount)
    if self.check_availability(what, amount)
      case what
        when 'Population'
          self.resource.update_attribute(:population, self.resource.population - amount.abs)
          to.resource.update_attribute(:population, to.resource.population + amount.abs)
        when 'Material'
          self.resource.update_attribute(:material, self.resource.material - amount.abs)
          to.resource.update_attribute(:material, to.resource.material + amount.abs)
	      when 'Parts'
		      self.resource.update_attribute(:parts, self.resource.parts - amount.abs)
		      to.resource.update_attribute(:parts, to.resource.parts + amount.abs)
        else
          "Toto nelze poslat"
      end
    else
      "Nedostatek surovin na odchozím léně"
    end
  end

  def check_availability(what, amount)
    case what
      when 'Population'
        self.resource.population >= amount
      when 'Material'
        self.resource.material >= amount
	    when 'Parts'
		    self.resource.parts >= amount
      else
        false
    end
  end

  scope :vlastnik, lambda { |user| where(:user_id => user.id) }


end
