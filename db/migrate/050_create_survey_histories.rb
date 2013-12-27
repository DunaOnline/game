class CreateSurveyHistory < ActiveRecord::Migration
	def change
		create_table :survey_histories do |t|
			t.text :content
			t.integer :house_id
			t.integer :subhouse_id
			t.integer :user_id
			t.integer :pro
			t.integer :proti

			t.timestamps
		end
	end
end
