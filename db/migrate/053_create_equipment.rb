class CreateEquipment < ActiveRecord::Migration
  def change
    create_table :equipment do |t|
      t.integer :product_id
      t.integer :unit_id


      t.timestamps
    end
  end
end
