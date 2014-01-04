class AddTypeToLaws < ActiveRecord::Migration
	def change
		add_column :laws, :druh, :string
	end
end
