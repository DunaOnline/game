class Research < ActiveRecord::Base
  attr_accessible :lvl, :technology_id, :user_id, :house_id, :subhouse_id

  belongs_to :user
  belongs_to :technology
  belongs_to :house
  belongs_to :subhouse
end
