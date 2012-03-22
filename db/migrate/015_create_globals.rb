class CreateGlobals < ActiveRecord::Migration
  def self.up
    create_table :globals do |t|
      t.string :setting, :null => false
      t.boolean :value, :null => true
      t.date :datum, :null => true
      t.string :slovo, :null => true
      t.decimal :cislo, :null => true, :precision => 12, :scale => 4

      t.timestamps
    end
  end

  def self.down
    drop_table :globals
  end
end
