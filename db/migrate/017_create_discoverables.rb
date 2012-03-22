class CreateDiscoverables < ActiveRecord::Migration
  def self.up
    create_table :discoverables do |t|
      t.string :name, :null => false
      t.integer :planet_type_id, :null => false
      t.string :system_name, :default => ""
      t.integer :position
      t.boolean :discovered, :default => false

      t.timestamps
    end
  end
  
  def self.down
    drop_table :discoverables
  end
end
