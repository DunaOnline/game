class Conversation < ActiveRecord::Base
	attr_accessible :message_id, :sender, :recipient, :deleted_by
	has_many :message

end
