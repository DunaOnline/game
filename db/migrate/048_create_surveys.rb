class CreateSurveys < ActiveRecord::Migration
	def change
		create_table :surveys do |t|
			t.text :content
			t.integer :house_id
			t.integer :subhouse_id
			t.integer :user_id

			t.timestamps
		end
	end
end
