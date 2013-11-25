class AddingDefaultValues < ActiveRecord::Migration
  def up
	  change_column :technologies, :technology_type, :string, :default => nil
	  change_column :technologies, :upgrade_building_lvl, :string, :default => nil
	  change_column :technologies, :house_id, :integer, :default => nil
	  change_column :technologies, :subhouse_id, :integer, :default => nil


	  change_column :buildings, :upg_mat_cost, :integer, :default => nil
	  change_column :buildings, :upg_mel_cost, :integer, :default => nil
	  change_column :buildings, :upg_sol_cost, :integer, :default => nil
	  change_column :buildings, :max_upg_lvl, :integer, :default => nil
	  change_column :buildings, :upg_profit, :integer, :default => nil

	  change_column :estates, :upgrade_lvl, :integer, :default => nil
  end

  def down
	  change_column :technologies, :technology_type, :string
	  change_column :technologies, :upgrade_building_lvl, :string
	  change_column :technologies, :house_id, :integer
	  change_column :technologies, :subhouse_id, :integer


	  change_column :buildings, :upg_mat_cost, :integer
	  change_column :buildings, :upg_mel_cost, :integer
	  change_column :buildings, :upg_sol_cost, :integer
	  change_column :buildings, :max_upg_lvl, :integer
	  change_column :buildings, :upg_profit, :integer

	  change_column :estates, :upgrade_lvl, :integer
  end
end
