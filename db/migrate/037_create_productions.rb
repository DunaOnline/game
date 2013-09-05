class CreateProductions < ActiveRecord::Migration
  def change
    create_table :productions do |t|
	    t.integer :resource_id
	    t.integer :user_id
	    t.integer :product_id
	    t.integer :amount
	    t.integer :house_id
	    t.integer :subhouse_id

      t.timestamps
    end
  end
end
