class CreateSubhouses < ActiveRecord::Migration
  def self.up
    create_table :subhouses do |t|
      t.string :name
      t.integer :house_id
      t.integer :solar
      t.decimal :melange
      t.decimal :material
      t.integer :exp
      t.timestamps
    end

    add_index :subhouses, :name
    add_index :subhouses, :house_id
  end

  def self.down
    drop_table :subhouses
  end
end
