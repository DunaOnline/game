class Research < ActiveRecord::Base
  attr_accessible :lvl, :technology_id, :user_id

  belongs_to :user
  belongs_to :technology
end
