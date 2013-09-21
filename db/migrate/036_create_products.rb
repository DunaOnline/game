class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
	    t.integer :house_id
	    t.integer :parts
	    t.string :title
	    t.string :description
	    t.decimal :material
	    t.decimal :melanz
	    t.integer :price
	    t.string :druh
	    t.string :img


      t.timestamps
    end
  end
end
