class AddDashboardToSubhouse < ActiveRecord::Migration
	def change
		add_column :subhouses, :dashboard, :text
	end
end
