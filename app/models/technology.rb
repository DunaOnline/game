class Technology < ActiveRecord::Base
  attr_accessible :description, :name, :price, :max_lvl, :bonus, :bonus_type, :image_url, :image_lvl

  has_many :researches
  has_many :users, :through => :researches
  has_one :effect

  validates_uniqueness_of :name

  def cena_technology(user)
       research = self.researches.where(:user_id => user).first
       if research
               ((research.lvl * 0.02)+1) * self.price
       else
               self.price
       end
  end

  def vylepsi(user)
     research = self.researches.where(:user_id => user.id).first
     if research
     research.update_attribute(:lvl, research.lvl+1)

   else
     Research.new(
       :technology_id => self.id,
       :lvl => 1 ,
       :user_id => user.id
     ).save
   end
   

 end



 def vylepseno(user)
    research = self.researches.where(:user_id => user).first
    if research
      research.lvl
    else
      0
    end
  end

  def vynalezene?(user)
    research = self.researches.where(:user_id => user).exists?
      return true
    else
      return false
    end
  end

  public
  def levely
    if self.image_lvl
    levely = self.image_lvl.split('*').map(&:to_i)
    end
    return levely
  end

def cesta_technologie(typ)
    cesta = "technologie/"
    case self.id
    when "1"
      cesta += "Investice-do-Infrastruktury/"
    when "2"
      cesta += "Investice-do-ekonomiky/"
    when "3"
      cesta += "Investice-do-prumyslu/"
    when "4"
      cesta += "Investice-do-vyzkumu/"
    when "5"
      cesta += "Investice-do-koreni/"
    when "6"
      cesta += "Investice-do-armady/"
    when "7"
      cesta += "Investice-do-vyroby/"
    when "8"
      cesta += "Investice-do-pechoty/"
    when "9"
      cesta += "Investice-do-flotily/"
    when "10"
      cesta += "Bojova-technika/"
    when "11"
      cesta += "Obrana-technologie/"
    end
    cesta += typ + ".png"
  
  end

  public :cesta_technologie


