class CreateEods < ActiveRecord::Migration
  def self.up
    create_table :eods do |t|
      t.integer :user_id, :null => false
      t.integer :field_id, :null => true
      t.date :date, :null => false, :default => Date.today
      t.time :time, :null => false, :default => Time.now
      t.integer :order, :null => false
      t.integer :solar_income, :precision => 12, :scale => 4, :default => 0.0
      t.integer :exp_income, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_income, :precision => 12, :scale => 4, :default => 0.0
      t.integer :population_income, :precision => 12, :scale => 4, :default => 0.0
      t.integer :solar_expense, :precision => 12, :scale => 4, :default => 0.0
      t.integer :exp_expense, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_expense, :precision => 12, :scale => 4, :default => 0.0
      t.integer :population_expense, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_income, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_expense, :precision => 12, :scale => 4, :default => 0.0
      t.integer :solar_store, :precision => 12, :scale => 4, :default => 0.0
      t.integer :exp_store, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material_store, :precision => 12, :scale => 4, :default => 0.0
      t.integer :population_store, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange_store, :precision => 12, :scale => 4, :default => 0.0
      t.integer :imperator
      t.integer :arrakis
      t.integer :leader
      t.string :mentats
      t.timestamps
    end
  end

  def self.down
    drop_table :eods
  end
end
