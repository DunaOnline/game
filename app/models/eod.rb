class Eod < ActiveRecord::Base
  attr_accessible :user_id, :field_id, :date, :time, :solar_income, :exp_income, :material_income, :population_income, :solar_expense, :exp_expense
  attr_accessible :material_expense, :population_expense, :melange_income, :melange_expense, :solar_store, :exp_store, :material_store
  attr_accessible :population_store, :melange_store, :imperator, :arrakis, :leader, :mentats, :order
  
  belongs_to :user
  
end
