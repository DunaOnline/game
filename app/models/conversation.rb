class Conversation < ActiveRecord::Base
	attr_accessible :message_id, :sender, :receiver, :deleted_by, :opened

	belongs_to :message
	belongs_to :user , :foreign_key => 'receiver'
end
