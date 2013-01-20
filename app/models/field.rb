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
      Resource.new(:user_id => self.user_id, :field_id => self.id, :population => 100000, :material => 2000.0).save
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

  def move_resource(to, what, amount)
    if self.check_availabilty(what, amount)
      target = Field.find(to)
      case what
        when 'Population'
          self.resource.update_attribute(:population, self.resource.population - amount.abs)
          target.resource.update_attribute(:population, target.resource.population + amount.abs)
        when 'Material'
          self.resource.update_attribute(:material, self.resource.material - amount.abs)
          target.resource.update_attribute(:material, target.resource.material + amount.abs)
        else
          "Toto nelze poslat"
      end
    else
      "Nedostatek surovin na odchozím léně"
    end
  end

  def check_availability(what, amount)
#    puts 'jsem ve field.rb'
#    puts self.to_yaml
#    puts Resource.all.to_yaml
#    puts self.resource.to_yaml
    case what
    when 'Population'
      self.resource.population >= amount
    when 'Material'
      self.resource.material >= amount
    else
      false
    end
  end
  
  scope :vlastnik, lambda { |user| where(:user_id => user.id)}
  
  
end
