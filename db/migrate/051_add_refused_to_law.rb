class AddRefusedToLaw < ActiveRecord::Migration
  def change
	  add_column :laws, :refused, :boolean
  end
end
