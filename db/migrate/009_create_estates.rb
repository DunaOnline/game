class CreateEstates < ActiveRecord::Migration
  def self.up
    create_table :estates do |t|
      t.integer :building_id, :null => false
      t.integer :field_id, :null => false
      t.integer :number, :null => false, :default => 1

      t.timestamps
    end

    add_index :estates, :building_id
    add_index :estates, :field_id
  end

  def self.down
    drop_table :estates
  end
end
