class CreateResources < ActiveRecord::Migration
  def self.up
    create_table :resources do |t|
      t.integer :user_id
      t.integer :field_id
      t.decimal :population, :precision => 12, :scale => 4, :default => 0.0
      t.decimal :material, :precision => 12, :scale => 4, :default => 0.0

      t.timestamps
    end
  end

  def self.down
    drop_table :resources
  end
end
