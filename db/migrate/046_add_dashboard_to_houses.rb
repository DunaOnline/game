class AddDashboardToHouses < ActiveRecord::Migration
  def change
	  add_column :houses, :house_dashboard, :text
  end

end
