class CreateInfluences < ActiveRecord::Migration
  def change
    create_table :influences do |t|
      t.integer :effect_id, :null => false
      t.integer :field_id, :null => false
      t.date :started_at, :default => Date.today

      t.timestamps
    end

    add_index :influences, :effect_id
    add_index :influences, :field_id
    add_index :influences, :started_at
  end
end
