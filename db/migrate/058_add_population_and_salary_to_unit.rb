class AddPopulationAndSalaryToUnit < ActiveRecord::Migration
  def change
	  add_column :units, :salary, :float
	  add_column :units, :img, :string
	  add_column :units, :population, :integer
	  add_column :units, :druh, :string
	  add_column :units, :lvl, :integer
	  add_column :units, :melange, :float
  end
end
