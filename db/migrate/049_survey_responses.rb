class SurveyResponses < ActiveRecord::Migration
	def change
		create_table :survey_responses do |t|
			t.integer :survey_id
			t.boolean :response
			t.integer :user_id

			t.timestamps
		end
	end
end
