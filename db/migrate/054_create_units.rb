class CreateUnits < ActiveRecord::Migration
  def change
    create_table :units do |t|
      t.string :name
      t.integer :house_id
      t.text :description
      t.integer :attack
      t.integer :defence
      t.integer :health
      t.integer :equipment
      t.float :material
<<<<<<< HEAD
      t.integer :solar
=======
      t.float :melange
      t.integer :solar
      t.integer :population
      t.float :salary
      t.string :img
      t.integer :lvl
      t.string :druh
>>>>>>> origin/Units

      t.timestamps
    end
  end
end
