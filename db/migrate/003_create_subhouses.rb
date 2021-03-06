class CreateSubhouses < ActiveRecord::Migration
  def self.up
    create_table :subhouses do |t|
      t.string :name
      t.integer :house_id
      t.decimal :solar, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :parts, :precision => 12, :scale => 4, :default => 0.0
      t.integer :exp, :default => 0
      t.timestamps
    end

    add_index :subhouses, :name
    add_index :subhouses, :house_id
  end

  def self.down
    drop_table :subhouses
  end
end
