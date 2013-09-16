class Market < ActiveRecord::Base
  attr_accessible :amount, :area, :price, :user_id, :created_at, :updated_at

  belongs_to :user
  has_many :market_histories

  validates_presence_of :amount, :area, :price

  def buy_goods(amount, user)
    amount = amount.to_i
    solary = user.solar.to_i
    quantity = self.amount
    seller = self.user


      if solary > 0 && quantity > 0 && amount > 0
	      if amount > 0 && quantity >= amount && solary >= amount * self.price
	        user.update_attribute(:solar, solary - amount * self.price)
	        user.goods_to_buyer(self.area, amount)
	        seller.update_attribute(:solar, seller.solar + amount * self.price)
	        self.zapis_obchodu(seller.id,"Bylo prodano #{amount} #{self.show_area} za celkem #{amount * self.price} solaru")
	        self.update_attribute(:amount, quantity - amount)
	        MarketHistory.new(
	            :amount => amount,
	            :market_id => self.id,
	            :user_id => user.id
	        ).save
	        self.zapis_obchodu(user.id,"Bylo nakoupeno #{amount} #{self.show_area} za celkem #{amount * self.price} solaru")
	      else
	        enough_for = solary / self.price if amount <= quantity
	        enough_for = quantity if amount > quantity
	        seller.update_attribute(:solar, seller.solar + enough_for * self.price)
	        self.zapis_obchodu(seller.id,"Bylo prodano #{enough_for} #{self.show_area} za celkem #{enough_for * self.price} solaru")
	        user.update_attribute(:solar, solary - enough_for * self.price)
	        user.goods_to_buyer(self.area, enough_for)
	        self.update_attribute(:amount, quantity - enough_for)
	        MarketHistory.new(
	            :amount => enough_for,
	            :market_id => self.id,
	            :user_id => user.id
	        ).save
	        self.zapis_obchodu(user.id,"Bylo nakoupeno #{enough_for} #{self.show_area} za celkem #{enough_for * self.price} solaru")
	      end
		 end
  end

  def discount
	  cena = self.price
    if cena != 1
      self.update_attribute(:price, cena * 0.9)
      self.zapis_obchodu(self.user_id,"Bylo zlevneno zbozi #{self.show_area} z #{cena} na #{self.price} solaru")
    end
  end

  def expensive
    cena = self.price
    cena = cena + 1 if (cena * 1.1).round == cena
    self.update_attribute(:price, (cena * 1.1).round)
    self.zapis_obchodu(self.user_id,"Bylo zdrazeno zbozi #{self.show_area} z #{cena} na #{self.price} solaru")

  end

  def seller(user)
    self.update_attribute(:user_id, user)
  end

  def show_area
    case self.area
      when "M"
        "Material"
      when "J"
        "Melanz"
      when "E"
        "Zkusenosti"
      when "P"
        "Populace"
	    when "V"
		    "Vyrobky"
	    else
		    Product.find(self.area).title
    end
  end

  def sell_goods(user)
    amount = self.amount
    case self.area
	    when "M"
        if amount > user.domovske_leno.resource.material
          return false
        else
          user.domovske_leno.resource.update_attribute(:material, user.domovske_leno.resource.material - amount)
          self.zapis_obchodu(user.id,"Bylo poslano na trh zbozi #{self.show_area}, #{amount} kg za #{self.price * amount} solaru")
        end
	    when "P"
        if amount > user.domovske_leno.resource.population
          return false
        else
          user.domovske_leno.resource.update_attribute(:population, user.domovske_leno.resource.population - amount)
          self.zapis_obchodu(user.id,"Bylo poslano na trh zbozi #{self.show_area}, #{amount} pop za #{self.price * amount} solaru")
        end
	    when "V"
		    if amount > user.domovske_leno.resource.parts
			    return false
		    else
			    user.domovske_leno.resource.update_attribute(:parts, user.domovske_leno.resource.parts - amount)
			    self.zapis_obchodu(user.id,"Bylo poslano na trh zbozi #{self.show_area}, #{amount} vyrobku za #{self.price * amount} solaru")
		    end
      when "J"
        if amount > user.melange
          return false
        else
          user.update_attribute(:melange, user.melange - amount)
          self.zapis_obchodu(user.id,"Bylo poslano na trh zbozi #{self.show_area}, #{amount} mg za #{self.price * amount} solaru")
        end
      when "E"
        if amount > user.exp
          return false
        else
          user.update_attribute(:exp, user.exp - amount)
          self.zapis_obchodu(user.id,"Bylo poslano na trh zbozi #{self.show_area}, #{amount} expu za #{self.price * amount} solaru")
        end
      else
		  production = user.domovske_leno.resource.productions.where(:product_id => self.area).first
        if amount > production.amount
	        return false
        else
	        production.update_attribute(:amount,production.amount - amount)
	        self.zapis_obchodu(user.id,"Bylo poslano na trh zbozi #{self.show_area}, #{amount} ks za #{self.price * amount} solaru")
        end

    end

  end

  def self.zobraz_trh(user)
	  markets = []

	  area = self.group(:area).all.map &:area
	  area.each do |market|
		  markets <<  self.where(["area = ? and user_id != ? and amount != ?", market, user, 0]).order(:price).first if self.where(["area = ? and user_id != ? and amount != ?", market, user, 0]).order(:price).first
	  end
		markets
  end

  def zapis_obchodu(user,content)
	  Operation.new(:kind => "U", :user_id => user, :content => content, :date => Date.today, :time => Time.now).save
  end

  scope :trh, where('amount > ?', 0)
  #scope :price_desc, order("markets.price  DESC ")
  #scope :created_desc, order("markets.created_at DESC")
  #scope :rozl, group(:area)
  scope :my_offers, ->(user) { where("user_id = ?", user) }

  #scope :material, where('area = ?', "M")
  #scope :cizi, ->(user) { where('user_id != ?', user) }
  #scope :melanz, where('area = ?', "J")
  #scope :expy, where('area = ?', "E")
  #scope :populacia, where('area = ?', "P")
  #scope :vyrobky, where('area = ?', "V")
  #scope :produkty, where('area > ?', 0)

end

