class CreateOrbits < ActiveRecord::Migration
  def change
    create_table :orbits do |t|
      t.integer :planet_id
      t.integer :ship_id
      t.integer :number
      t.integer :user_id

      t.timestamps
    end
  end
end
