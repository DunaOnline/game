class Market < ActiveRecord::Base
  after_initialize :default_values

  attr_accessible :amount, :area, :price, :user_id, :created_at, :updated_at

  belongs_to :user
  belongs_to :house
  belongs_to :subhouse
  has_many :market_histories

  validates_presence_of :amount, :area, :price


  def buy_goods(amount, user)
    amount = amount.to_f
    solary = user.solar
    if self.before_buy_check(user, amount)
      if self.buy_check(user, amount)
        self.b_goods_u(amount, user) if self.s_goods(amount)
      else
        enough_for = (solary / self.price).round(2) if amount <= self.amount
        enough_for = self.amount if amount > self.amount
        enough_for -= 0.01 if enough_for * self.price > solary
        self.b_goods_u(enough_for, user) if self.s_goods(enough_for)
      end
    end
  end

  def b_goods_u(amount, user)
    user.update_attribute(:solar, (user.solar - amount * self.price).round(2))
    user.goods_to_buyer(self.area, amount)
    self.update_attribute(:amount, self.amount - amount)
    MarketHistory.new(
        :amount => amount,
        :market_id => self.id,
        :user_id => user.id
    ).save
    self.zapis_obchodu(user.id, "Bylo nakoupeno #{amount} #{self.show_area} za celkem #{amount * self.price} solaru")
  end

  def buy_goods_house(amount, house)
    buyer_house = House.find(house)
    if self.before_buy_check(buyer_house, amount)
      if self.buy_check(buyer_house, amount)
        self.b_goods_h(amount, buyer_house) if self.s_goods(amount)
      else
        enough_for = (buyer_house.solar / self.price).round(2)
        enough_for = self.amount if enough_for > self.amount
        enough_for -= 0.01 if enough_for * self.price > buyer_house.solar
        self.b_goods_h(enough_for, buyer_house) if self.s_goods(enough_for)
      end
    end
  end

  def s_goods(amount)
    flag = self.user.update_attribute(:solar, self.user.solar + amount * self.price) if self.user_id > 0
    self.user.zapis_operaci("Bylo prodano #{amount} #{self.show_area} za celkem #{amount * self.price} solaru") if self.user_id > 0
    flag = self.subhouse.update_attribute(:solar, self.subhouse.solar + amount * self.price) if self.subhouse
    self.subhouse.zapis_operaci("Bylo prodano #{amount} #{self.show_area} za celkem #{amount * self.price} solaru") if self.subhouse
    flag = self.house.update_attribute(:solar, self.house.solar + amount * self.price) if self.house
    self.house.zapis_operaci("Bylo prodano #{amount} #{self.show_area} za celkem #{amount * self.price} solaru") if self.house
    flag
  end

  def b_goods_h(amount, buyer_house)
    buyer_house.update_attribute(:solar, (buyer_house.solar - amount * self.price).round(2))
    buyer_house.goods_to_buyer(self.area, amount)
    self.update_attribute(:amount, self.amount - amount)
    MarketHistory.new(
        :amount => amount,
        :market_id => self.id,
        :house_id => buyer_house.id
    ).save
    buyer_house.zapis_operaci("Bylo nakoupeno #{amount} #{self.show_area} za celkem #{amount * self.price} solaru")
  end

  def buy_goods_subhouse(amount, subhouse)
    buyer_suhouse = Subhouse.find(subhouse)
    if self.before_buy_check(buyer_suhouse, amount)
      if self.buy_check(buyer_suhouse, amount)
        self.b_goods_mr(amount, buyer_suhouse) if self.s_goods(amount)
      else
        enough_for = (buyer_suhouse.solar / self.price).round(2) if amount <= self.amount
        enough_for = self.amount if amount > self.amount
        enough_for -= 0.01 if enough_for * self.price > buyer_suhouse.solar
        self.b_goods_mr(enough_for, buyer_suhouse) if self.s_goods(enough_for)
      end
    end
  end

  def b_goods_mr(amount, buyer_subhouse)
    buyer_subhouse.update_attribute(:solar, (buyer_subhouse.solar - amount * self.price).round(2))
    buyer_subhouse.goods_to_buyer(self.area, amount)
    self.update_attribute(:amount, self.amount - amount)
    MarketHistory.new(
        :amount => amount,
        :market_id => self.id,
        :house_id => buyer_subhouse.id
    ).save
    buyer_subhouse.zapis_operaci("Bylo nakoupeno #{amount} #{self.show_area} za celkem #{amount * self.price} solaru")
  end

  def whos_buying(who, user, amount)
    zap = "Nemate dost solaru na nakup"
    flag = false
    case who
      when "U"
        if self.area.to_i > 0
          if user.miesto_v_tovarni?(amount)
            msg = "Zbozi bylo nakoupeno" if self.buy_goods(amount, user)
          else
            zap = "Nemate dost miesta v tovarne"
          end
        else
          msg = "Zbozi bylo nakoupeno" if self.buy_goods(amount, user)
        end
      when "MR"
        if self.area.to_i > 0
          if user.subhouse.miesto_v_tovarni?(amount)
            msg = "Zbozi bylo nakoupeno" if self.buy_goods_subhouse(amount, user.subhouse)
          else
            zap = "Nemate dost miesta v tovarne"
          end
        else
          msg = "Zbozi bylo nakoupeno" if self.buy_goods_subhouse(amount, user.subhouse)
        end
      when "H"
        if self.area.to_i > 0
          if user.house.miesto_v_tovarni?(amount)
            msg = "Zbozi bylo nakoupeno" if self.buy_goods_house(amount, user.house)
          else
            zap = "Nemate dost miesta v tovarne"
          end
        else
          msg = "Zbozi bylo nakoupeno" if self.buy_goods_house(amount, user.house)
        end

    end
    flag = true if msg
    msg = zap unless msg
    return msg, flag
  end

  def buy_check(who, amount)
    self.amount >= amount && who.solar >= self.price * amount
  end

  def before_buy_check(who, amount)
    who.solar > 0 && self.amount > 0
  end

  def discount
    cena = self.price
    if cena != 1
      self.update_attribute(:price, cena * 0.9)
      self.zapis_obchodu(self.user_id, "Bylo zlevneno zbozi #{self.show_area} z #{cena} na #{self.price} solaru")
    end
  end

  def expensive
    cena = self.price
    cena = cena + 1 if (cena * 1.1).round == cena
    self.update_attribute(:price, (cena * 1.1).round)
    self.zapis_obchodu(self.user_id, "Bylo zdrazeno zbozi #{self.show_area} z #{cena} na #{self.price} solaru")

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


  def self.zobraz_trh(user)
    markets = []

    area = self.group(:area).all
    area.each do |market|
      markets << self.where(["area = ? and user_id != ? and amount != ?", market.area, user.id, 0]).order(:price).first if self.where(["area = ? and user_id != ? and amount != ?", market.area, user.id, 0]).order(:price).first
    end
    markets
  end

  def self.zobraz_trh_mr(mr)
    markets = []

    area = self.group(:area).all
    area.each do |market|
      markets << self.where(["area = ? and subhouse_id != ? and amount != ?", market.area, mr.id, 0]).order(:price).first if self.where(["area = ? and subhouse_id != ? and amount != ?", market.area, mr.id, 0]).order(:price).first
    end
    markets
  end

  def self.zobraz_trh_house(house)
    markets = []

    area = self.group(:area).all
    area.each do |market|
      markets << self.where(["area = ? and house_id != ? and amount != ? ", market.area, house.id, 0]).order(:price).first if self.where(["area = ? and house_id != ? and amount != ? ", market.area, house.id, 0]).order(:price).first
    end
    markets
  end

  def zapis_obchodu(user, content)
    Operation.new(:kind => "U", :user_id => user, :content => content, :date => Date.today, :time => Time.now).save
  end

  def nemate_dost
    "Nemate dost #{self.show_area} na predaj"
  end

  def stahnout_wrap(user)
	  user.goods_to_buyer(self.area, (self.amount * Constant.stiahnut_zbozi_trh).ceil) if self.area == "E" && self.user_id > 0
	  user.goods_to_buyer(self.area, self.amount * Constant.stiahnut_zbozi_trh).round(2) if self.area != "E" && self.user_id > 0
	  user.subhouse.goods_to_buyer(self.area, (self.amount * Constant.stiahnut_zbozi_trh).ceil) if self.area == "E" && self.subhouse_id > 0
	  user.subhouse.goods_to_buyer(self.area, self.amount * Constant.stiahnut_zbozi_trh).round(2) if self.area != "E" && self.subhouse_id > 0
	  user.house.goods_to_buyer(self.area, (self.amount * Constant.stiahnut_zbozi_trh).ceil) if self.area == "E" && self.house_id > 0
	  user.house.goods_to_buyer(self.area, self.amount * Constant.stiahnut_zbozi_trh).round(2) if self.area != "E" && self.house_id > 0
  end

  private
  def default_values
    self.user_id ||= 0
    self.house_id ||= 0
    self.subhouse_id ||= 0
  end


  scope :trh, where('amount > ?', 0)

  scope :my_offers, ->(user) { where("user_id = ?", user) }
  scope :my_offers_subhouse, ->(subhouse) { where("subhouse_id = ?", subhouse) }
  scope :my_offers_house, ->(house) { where("house_id = ?", house) }


end

