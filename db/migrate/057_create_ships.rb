class CreateShips < ActiveRecord::Migration
  def change
    create_table :ships do |t|
      t.string :name
      t.string :description
      t.integer :equipment
      t.integer :attack
      t.integer :defence
      t.integer :health
      t.integer :population
      t.float :material
      t.float :solar
      t.float :salary

      t.timestamps
    end
  end
end
