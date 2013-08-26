class CreateMarkets < ActiveRecord::Migration
  def change
    create_table :markets do |t|
      t.string :area
      t.integer :user_id
      t.integer :price
      t.float :amount

      t.timestamps
    end
  end
end
