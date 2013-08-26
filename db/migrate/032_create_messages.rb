class CreateMessages < ActiveRecord::Migration
  def change
    create_table :messages do |t|
      t.string :body
      t.string :subject
      t.string :recipients
      t.string :conversations
      t.string :druh
      t.boolean :read

      t.timestamps
    end
  end
end
