class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.integer :product_id
      t.integer :unit_id
<<<<<<< HEAD
      t.integer :durability
=======

>>>>>>> origin/Units

      t.timestamps
    end
  end
end
