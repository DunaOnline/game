class Orbit < ActiveRecord::Base
  attr_accessible :number, :planet_id, :ship_id
end
