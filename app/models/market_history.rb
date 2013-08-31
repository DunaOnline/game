class MarketHistory < ActiveRecord::Base
  attr_accessible :amount, :market_id, :user_id

  belongs_to :market
  has_many :users, :through => :market
end
