class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :house_id, :null => false
      t.integer :elector, :null => false
      t.integer :elective, :null => false
      t.string :typ, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end
