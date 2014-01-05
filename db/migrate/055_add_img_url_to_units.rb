class AddImgUrlToUnits < ActiveRecord::Migration
  def change
	  add_column :units, :img, :string
	  add_column :units, :lvl, :integer
	  add_column :units, :druh, :string
  end
end
