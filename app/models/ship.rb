class Ship < ActiveRecord::Base
  attr_accessible :attack, :defence, :description, :equipment, :health, :material, :name, :population, :salary, :solar
end
