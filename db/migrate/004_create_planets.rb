class CreatePlanets < ActiveRecord::Migration
  def self.up
    create_table :planets do |t|
      t.string :name, :null => false
      t.integer :planet_type_id, :null => false
      t.integer :house_id, :null => true
      t.string :system_name
      t.integer :position
      t.boolean :available_to_all, :default => false
      t.date :discovered_at, :default => Date.today
      t.timestamps
    end

    add_index :planets, :name
    add_index :planets, :planet_type_id
    add_index :planets, :house_id
  end

  def self.down
    drop_table :planets
  end
end
