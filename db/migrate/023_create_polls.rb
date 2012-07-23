class CreatePolls < ActiveRecord::Migration
  def change
    create_table :polls do |t|
      t.integer :user_id
      t.integer :law_id
      t.string :choice, :null => false

      t.timestamps
    end
  end
end
