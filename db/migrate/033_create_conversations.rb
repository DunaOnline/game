class CreateConversations < ActiveRecord::Migration
  def change
    create_table :conversations do |t|
	    t.integer :sender
	    t.integer :message_id
	    t.integer :receiver
	    t.string :deleted_by
	    t.boolean :opened

      t.timestamps
    end
  end
end
