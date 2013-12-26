class Survey < ActiveRecord::Base
	attr_accessible :content, :house_id, :subhouse_id, :user_id

	validates_presence_of :content
end
