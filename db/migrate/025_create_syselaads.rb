class CreateSyselaads < ActiveRecord::Migration
  def self.up
    create_table :syselaads do |t|
      t.integer :house_id
      t.integer :subhouse_id
      t.string :kind, :null => false
      t.string :name, :null => false
      t.string :description
      t.timestamps
    end
  end

  def self.down
    drop_table :syselaads
  end
end
