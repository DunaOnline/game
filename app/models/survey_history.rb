class SurveyHistory < ActiveRecord::Base
   attr_accessible :content, :user_id, :subhouse_id, :house_id, :pro, :proti
end
