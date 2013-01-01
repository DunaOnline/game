# == Schema Information
#
# Table name: eods
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  field_id           :integer
#  date               :date             default(Thu, 13 Dec 2012), not null
#  time               :time             default(2000-01-01 21:48:25 UTC), not null
#  order              :integer          not null
#  solar_income       :integer          default(0)
#  exp_income         :integer          default(0)
#  material_income    :decimal(12, 4)   default(0.0)
#  population_income  :integer          default(0)
#  solar_expense      :integer          default(0)
#  exp_expense        :integer          default(0)
#  material_expense   :decimal(12, 4)   default(0.0)
#  population_expense :integer          default(0)
#  melange_income     :decimal(12, 4)   default(0.0)
#  melange_expense    :decimal(12, 4)   default(0.0)
#  solar_store        :integer          default(0)
#  exp_store          :integer          default(0)
#  material_store     :decimal(12, 4)   default(0.0)
#  population_store   :integer          default(0)
#  melange_store      :decimal(12, 4)   default(0.0)
#  imperator          :integer
#  arrakis            :integer
#  leader             :integer
#  mentats            :string(255)
#  created_at         :datetime
#  updated_at         :datetime
#

class Eod < ActiveRecord::Base
  attr_accessible :user_id, :field_id, :date, :time, :solar_income, :exp_income, :material_income, :population_income, :solar_expense, :exp_expense
  attr_accessible :material_expense, :population_expense, :melange_income, :melange_expense, :solar_store, :exp_store, :material_store
  attr_accessible :population_store, :melange_store, :imperator, :arrakis, :leader, :mentats, :order
  
  belongs_to :user
  
end
