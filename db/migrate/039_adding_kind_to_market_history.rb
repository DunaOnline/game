class AddingKindToMarketHistory < ActiveRecord::Migration
  def up
	  add_column :market_histories, :house_id, :integer
	  add_column :market_histories, :subhouse_id, :integer
  end

  def down
	  remove_column :market_histories, :subhouse_id, :integer
	  remove_column :market_histories, :house_id, :integer
  end
end
