class CreateTechnologies < ActiveRecord::Migration
  def change
    create_table :technologies do |t|
      t.string :name
      t.text :description
      t.integer :price
      t.integer :max_lvl
      t.decimal :bonus
      t.string :bonus_type
      t.string :image_url
      t.string :image_lvl
      t.integer :discovered

      t.timestamps
    end
  end
end
