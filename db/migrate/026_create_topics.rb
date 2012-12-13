class CreateTopics < ActiveRecord::Migration
  def self.up
    create_table :topics do |t|
      t.integer :syselaad_id, :null => false
      t.integer :user_id, :null => false
      t.string :name, :null => false
      t.integer :last_poster_id
      t.datetime :last_post_at
      t.timestamps
    end
  end

  def self.down
    drop_table :topics
  end
end
