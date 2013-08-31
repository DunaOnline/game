class Market < ActiveRecord::Base
  attr_accessible :amount, :area, :price, :user_id, :created_at, :updated_at

  belongs_to :user
  has_many :market_histories

  validates_presence_of :amount, :area, :price

  def buy_goods(amount, user)
    amount = amount.to_i
    market = self
    solary = user.solar.to_i
    quantity = market.amount
    seller = market.user

    if solary > 0 && quantity > 0 && amount > 0
      if amount > 0 && quantity >= amount && solary >= amount * market.price
        user.update_attribute(:solar, solary - amount * market.price)
        user.goods_to_buyer(market.area, amount)
        seller.update_attribute(:solar, seller.solar + amount * market.price)
        market.update_attribute(:amount, quantity - amount)
        MarketHistory.new(
            :amount => amount,
            :market_id => market.id,
            :user_id => user.id
        ).save
      else
        enough_for = solary / market.price if amount <= quantity
        enough_for = quantity if amount > quantity
        seller.update_attribute(:solar, seller.solar + enough_for * market.price)
        user.update_attribute(:solar, solary - enough_for * market.price)
        user.goods_to_buyer(market.area, enough_for)
        market.update_attribute(:amount, quantity - enough_for)
        MarketHistory.new(
            :amount => enough_for,
            :market_id => market.id,
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
    end
  end

  def what_goods(user)
    market = self
    amount = market.amount

    case market.area
      when "M"
        material_na_pl = user.domovske_leno.resource.material
        if amount > material_na_pl
          return false
        else
          user.domovske_leno.resource.update_attribute(:material, material_na_pl - amount)
        end
      when "P"
        pop_na_pl = user.domovske_leno.resource.population
        if amount > pop_na_pl
          return false
        else
          user.domovske_leno.resource.update_attribute(:population, pop_na_pl - amount)
        end
      when "J"
        u_melange = user.melange
        if amount > u_melange || u_melange < amount
          return false
        else
          user.update_attribute(:melange, u_melange - amount)
        end
      when "E"
        u_expy = user.exp
        if amount > u_expy || u_expy < amount
          return false
        else
          user.update_attribute(:exp, u_expy - amount)
        end
      else
        return
    end

  end

  scope :trh, where('amount > ?', 0)
  scope :price_desc, order("markets.price  DESC ")
  scope :created_desc, order("markets.created_at DESC")
  scope :rozl, group(:area)
  scope :my_offers, ->(user) { where("user_id = ?", user) }

  scope :material, where('area = ?', "M")
  scope :moje, ->(user) { where('user_id != ?', user) }
  scope :melanz, where('area = ?', "J")
  scope :expy, where('area = ?', "E")
  scope :populacia, where('area = ?', "P")

end

