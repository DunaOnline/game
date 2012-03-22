class CreatePlanetTypes < ActiveRecord::Migration
  def self.up
    create_table :planet_types do |t|
      t.string :name, :null => false
      t.decimal :fields, :precision => 4, :scale => 0, :default => 0
      t.decimal :population_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :pop_limit_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :solar_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.timestamps
    end

    add_index :planet_types, :name
  end

  def self.down
    drop_table :planet_types
  end
end
