class CreateHouses < ActiveRecord::Migration
  def self.up
    create_table :houses do |t|
      t.string :name, :null => false
      t.string :leader
      t.decimal :solar, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp, :precision => 12, :scale => 4, :default => 0.0
      t.boolean :playable, :default => true
      t.decimal :melange_percent, :precision => 12, :scale => 4, :default => 0.0
      t.timestamps
    end

    add_index :houses, :name
  end

  def self.down
    drop_table :houses
  end
end
