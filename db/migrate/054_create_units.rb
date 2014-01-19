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
      t.integer :solar
      t.float :melange
      t.integer :solar
      t.integer :population

      t.string :img
      t.integer :lvl
      t.string :druh
      t.float :salary


      t.timestamps
    end
  end
end
