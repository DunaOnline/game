class DeleteTempRecordTable < ActiveRecord::Migration
  def up
	  drop_table :temporary_records
	  add_column :eods, :parts_store, :float, :default => 0.0
	  add_column :eods, :parts_income, :float, :default => 0.0
	  add_column :eods, :parts_expense, :float, :default => 0.0
	  add_column :houses, :pocet_vyhosteni, :integer, :default => 0
	  add_column :subhouses, :pocet_vyhosteni, :integer, :default => 0
	  change_column :eods, :solar_store, :float
	  change_column :eods, :solar_income, :float
	  change_column :eods, :solar_expense, :float
    Global.create(:setting => 'zapnout_nahodnou_produkci', :value => true)
	  Global.create(:setting => 'pocet_vyhosteni_narod', :cislo => 5)
	  Global.create(:setting => 'pocet_vyhosteni_mr', :cislo => 3)

  end

  def down
	  create_table :temporary_records do |t|
		  t.string :setting
		  t.integer :user_id
		  t.integer :house_id
		  t.integer :subhouse_id
		  t.integer :cislo
		  t.string :text
		  t.timestamps
	  end
	  remove_column :eods, :parts_store, :float, :default => 0.0
	  remove_column :eods, :parts_income, :float, :default => 0.0
	  remove_column :eods, :parts_expense, :float, :default => 0.0
	  remove_column :houses, :pocet_vyhosteni, :integer, :default => 0
	  remove_column :subhouses, :pocet_vyhosteni, :integer, :default => 0
	  change_column :eods, :solar_store, :integer
	  change_column :eods, :solar_income, :integer
	  change_column :eods, :solar_expense, :integer
  end
end
