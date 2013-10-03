class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.string :subject
      t.string :recipients
      t.integer :user_id
      t.string :druh
      t.boolean :opened

      t.timestamps
    end
  end
end
