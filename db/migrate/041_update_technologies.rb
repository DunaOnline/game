class UpdateTechnologies < ActiveRecord::Migration
  def up
	  add_column :technologies, :technology_type, :string
	  add_column :technologies, :upgrade_building_lvl, :string
	  add_column :technologies, :house_id, :integer
	  add_column :technologies, :subhouse_id, :integer


	  add_column :buildings, :upg_mat_cost, :integer
	  add_column :buildings, :upg_mel_cost, :integer
	  add_column :buildings, :upg_sol_cost, :integer
	  add_column :buildings, :max_upg_lvl, :integer
	  add_column :buildings, :upg_profit, :integer

	  add_column :estates, :upgrade_lvl, :integer

	  create_table :temporary_records do |t|
		  t.string :setting
		  t.integer :user_id
		  t.integer :house_id
		  t.integer :subhouse_id
		  t.integer :cislo
		  t.string :text
		  t.timestamps
	  end
  end

  def down
	  remove_column :technologies, :technology_type, :string
	  remove_column :technologies, :house_id, :integer
	  remove_column :technologies, :subhouse_id, :integer
	  remove_column :technologies, :upgrade_building_lvl, :string


	  remove_column :buildings, :upg_mat_cost, :integer
	  remove_column :buildings, :upg_mel_cost, :integer
	  remove_column :buildings, :upg_sol_cost, :integer
	  remove_column :buildings, :max_upg_lvl, :integer
	  remove_column :buildings, :upg_profit, :integer

	  remove_column :estates, :upgrade_lvl, :integer

	  drop_table :temporary_records
  end
end
