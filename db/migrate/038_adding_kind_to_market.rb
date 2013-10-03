class AddingKindToMarket < ActiveRecord::Migration
  def up
	  add_column :markets, :house_id, :integer
	  add_column :markets, :subhouse_id, :integer
  end

  def down
	  remove_column :markets, :subhouse_id, :integer
	  remove_column :markets, :house_id, :integer
  end
end
