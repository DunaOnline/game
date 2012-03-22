class CreateEnvironments < ActiveRecord::Migration
  def self.up
    create_table :environments do |t|
      t.integer :planet_id, :null => false
      t.integer :property_id, :null => false
      t.date :started_at, :default => Date.today

      t.timestamps
    end

    add_index :environments, :planet_id
    add_index :environments, :property_id
    add_index :environments, :started_at
  end

  def self.down
    drop_table :environments
  end
end
