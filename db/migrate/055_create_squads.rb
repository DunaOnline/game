class CreateSquads < ActiveRecord::Migration
  def change
    create_table :squads do |t|
      t.integer :field_id
      t.integer :unit_id

      t.timestamps
    end
  end
end
