class CreateLaws < ActiveRecord::Migration
  def change
    create_table :laws do |t|
      t.string :label, :null => false
      t.string :title, :null => false
      t.text :content
      t.string :state, :null => false
      t.integer :position
      t.integer :submitter, :null => false
      t.datetime :submitted
      t.datetime :enacted
      t.datetime :signed

      t.timestamps
    end
  end
end
