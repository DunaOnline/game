class CreateFields < ActiveRecord::Migration
  def self.up
    create_table :fields do |t|
      t.integer :user_id#, :null => false
      t.integer :planet_id, :null => false
      t.string :name, :null => false
      t.decimal :pos_x, :default => 0.0
      t.decimal :pos_y, :default => 0.0
      t.timestamps
    end

    add_index :fields, :user_id
    add_index :fields, :planet_id
  end

  def self.down
    drop_table :fields
  end
end
