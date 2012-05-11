class CreateOperations < ActiveRecord::Migration
  def self.up
    create_table :operations do |t|
      t.integer :user_id, :null => false
      t.integer :house_id, :null => false
      t.integer :subhouse_id, :null => false
      t.string :kind
      t.string :content
      t.date :date, :default => Date.today
      t.time :time, :default => Time.now
      t.timestamps
    end
  end

  def self.down
    drop_table :operations
  end
end
