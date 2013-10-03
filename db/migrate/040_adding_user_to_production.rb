class AddingUserToProduction < ActiveRecord::Migration
	def up
		add_column :productions, :user_id, :integer

	end

	def down
		remove_column :productions, :user_id, :integer

	end
end
