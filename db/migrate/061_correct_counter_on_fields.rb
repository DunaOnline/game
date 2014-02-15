class CorrectCounterOnFields < ActiveRecord::Migration
	def self.up
		remove_column :users, :field_count
		add_column :users, :fields_count, :integer, :default => 0

		User.reset_column_information
		User.all.each do |f|
			User.reset_counters f.id, :fields
		end
	end

	def self.down
		remove_column :users, :fields_count
	end


end
