class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :username, :null => false
      t.string :nick, :null =>false
      t.string :email
      t.string :password_hash
      t.string :password_salt
      t.integer :house_id, :null => false
      t.integer :subhouse_id, :null => true
      t.decimal :solar, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :melange, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :exp, :precision => 12, :scale => 4, :default => 0.0
      t.boolean :leader, :default => false
      t.boolean :mentat, :default => false
      t.boolean :army_mentat, :default => false
      t.boolean :diplomat, :default => false
      t.boolean :general, :default => false
      t.boolean :vicegeneral, :default => false
      t.boolean :landsraad, :default => false
      t.boolean :arrakis, :default => false
      t.boolean :emperor, :default => false
      t.boolean :regent, :default => false
      t.boolean :court, :default => false
      t.boolean :vezir, :default => false
      t.boolean :admin, :default => false
      t.timestamps
    end

    add_index :users, :username
    add_index :users, :house_id
    add_index :users, :subhouse_id
  end

  def self.down
    drop_table :users
  end
end
