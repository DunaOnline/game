class CreateMarketHistories < ActiveRecord::Migration
  def change
    create_table :market_histories do |t|
      t.integer :market_id
      t.decimal :amount
      t.integer :user_id

      t.timestamps
    end
  end
end
