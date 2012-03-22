class CreateEffects < ActiveRecord::Migration
  def self.up
    create_table :effects do |t|
      t.string :name, :null => false
      t.decimal :population_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :pop_limit_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :solar_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp_bonus, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :duration, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :population_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :solar_cost, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp_cost, :precision => 12, :scale => 4, :default => 0.0
      t.timestamps
    end

    add_index :effects, :name
  end

  def self.down
    drop_table :effects
  end
end
