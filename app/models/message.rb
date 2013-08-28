class Message < ActiveRecord::Base
  attr_accessible :body, :subject, :read, :recipients,:user_id, :druh
	has_many :conversations
	belongs_to :user

	validates_presence_of :subject, :body




	def zisti_id_prijemcu(komu)
				user = User.where('nick' => komu).first
				if user
					user.id
				else
					return false
				end
	end

	def vymaz(user,odoslana)
		if odoslana
		recipients = Conversation.where('sender' => user, 'message_id' => self.id)
			recipients.each do |r|
				r.update_attributes(:deleted_by => "S")
			end
		else
			recipients = Conversation.where('recipient' => user, 'message_id' => self.id)
			recipients.each do |r|
				r.update_attributes(:deleted_by => "R")
			end
		end
	end


	def posli_postu(odosielatel, komu)
		self.update_attribute(:user_id, odosielatel.id)
		narod = odosielatel.house_id
		malorod = odosielatel.subhouse_id
		case self.druh
			when "M"
				recipients = User.where(:subhouse_id => malorod, :house_id => narod)
			when "G"
				recipients = User.where(:general => true, :house_id => narod)
			when "N"
				recipients = User.where(:house_id => narod)
			when "D"
				recipients = User.where(:house_id => narod, :diplomat => true)
			when "I"
				recipients = User.all
			else
				recipients = []
		end
		recipients.each do |recipient|
		self.vytvor_postu(odosielatel,recipient.nick)
		end

		#if komu
		#	prijemci = komu.split(",")
		#	index = 0
		#	while index < prijemci.length
		#		prijemca = prijemci[index].strip
		#
		#		prijemca = prijemca[1..prijemca.length] if index >0
		#		user = nil
		#		user = User.find(self.zisti_id_prijemcu(prijemca)) if prijemca != "" and prijemca != nil
		#
		#		if user && user != odosielatel.id
		#			self.vytvor_postu(odosielatel,prijemca)
		#		end
		#		index += 1
		#	end
		#end
		if komu
			komu.split(",").each do |recipient|


				recipient = recipient.strip


				user = nil
				user = User.find(self.zisti_id_prijemcu(recipient)) if recipient != "" and recipient != nil

				#if user && user.id != odosielatel.id
					self.vytvor_postu(odosielatel,recipient)
				#else
					#return false
				#end

			end
		end
	end

	def vytvor_postu(odosielatel, komu)
		#asi zbytocna podmienka musim sa na to pozriet uz hore to nprejde pokial nieje prijemca
		if self.zisti_id_prijemcu(komu)
		Conversation.new(
				:message_id => self.id,
				:sender => odosielatel.id,
				:recipient => (self.zisti_id_prijemcu(komu))
		).save
		end
	end

	def procist(posta)
		posta.update_attribute(:read, true)
	end
end




