class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
	    t.integer :sender
	    t.integer :message_id
	    t.integer :recipient
	    t.string :deleted_by

      t.timestamps
    end
  end
end
