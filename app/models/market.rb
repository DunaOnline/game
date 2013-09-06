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
	        self.update_attribute(:amount, quantity - amount)
	        MarketHistory.new(
	            :amount => amount,
	            :market_id => self.id,
	            :user_id => user.id
	        ).save
	      else
	        enough_for = solary / self.price if amount <= quantity
	        enough_for = quantity if amount > quantity
	        seller.update_attribute(:solar, seller.solar + enough_for * self.price)
	        user.update_attribute(:solar, solary - enough_for * self.price)
	        user.goods_to_buyer(self.area, enough_for)
	        self.update_attribute(:amount, quantity - enough_for)
	        MarketHistory.new(
	            :amount => enough_for,
	            :market_id => self.id,
	            :user_id => user.id
	        ).save
	      end
		 end
  end

  def discount
    cena = self.price
    if price != 1
      self.update_attribute(:price, cena * 0.9)
    end
  end

  def expensive
    cena = self.price
    cena = cena + 1 if (cena * 1.1).round == cena
    self.update_attribute(:price, (cena * 1.1).round)

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
        end
	    when "P"
        if amount > user.domovske_leno.resource.population
          return false
        else
          user.domovske_leno.resource.update_attribute(:population, user.domovske_leno.resource.population - amount)
        end
	    when "V"
		    if amount > user.domovske_leno.resource.parts
			    return false
		    else
			    user.domovske_leno.resource.update_attribute(:parts, user.domovske_leno.resource.parts - amount)
		    end
      when "J"
        if amount > user.melange
          return false
        else
          user.update_attribute(:melange, user.melange - amount)
        end
      when "E"
        if amount > user.exp
          return false
        else
          user.update_attribute(:exp, user.exp - amount)
        end
      else
		  production = user.domovske_leno.resource.productions.where(:product_id => self.area).first
        if amount > production.amount
	        return false
        else
	        production.update_attribute(:amount,production.amount - amount)
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

