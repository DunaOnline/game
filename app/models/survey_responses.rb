class SurveyResponses < ActiveRecord::Base
   attr_accessible :survey_id, :response, :user_id
end
