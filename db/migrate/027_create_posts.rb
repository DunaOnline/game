class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :topic_id, :null => false
      t.integer :user_id, :null => false
      t.text :content, :null => false
      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
