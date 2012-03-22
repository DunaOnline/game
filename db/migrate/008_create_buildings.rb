class CreateBuildings < ActiveRecord::Migration
  def self.up
    create_table :buildings do |t|
      t.string :kind, :null => false
      t.integer :level, :null => false
      t.string :name, :null => false
      t.text :description, :default => ""
      t.decimal :population_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :pop_limit_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :solar_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :population_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :solar_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp_cost, :precision => 12, :scale => 4, :default => 0.0
      t.integer :prerequisity_1, :default => nil
      t.integer :prerequisity_2, :default => nil
      t.integer :prerequisity_3, :default => nil
      t.timestamps
    end

    add_index :buildings, :kind
    add_index :buildings, :level
    add_index :buildings, :name
  end

  def self.down
    drop_table :buildings
  end
end
