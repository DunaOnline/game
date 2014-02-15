class AddFieldCounterToUser < ActiveRecord::Migration
	def self.up
		add_column :users, :field_count, :integer, :default => 0

		User.reset_column_information
		User.all.each do |f|
			f.update_attribute :field_count, f.fields.length
		end
	end

	def self.down
		remove_column :users, :field_count
	end
end
