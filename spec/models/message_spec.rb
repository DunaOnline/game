require "spec_helper"

describe Message do

	it "Should get the id of receiver" do
		user  = create(:user, :nick => "opica")
		message = create(:message)

		expect(message.zisti_id_prijemcu(user.nick)).to eq(user.id)
		expect(message.zisti_id_prijemcu("ufon")).to eq(false)
	end

	it "Should read the message" do
		user  = create(:user)
		message = create(:message)
		conversation = create(:conversation, :message_id => message.id, :receiver => user.id, :opened => false)
		conversation2 = create(:conversation, :message_id => message.id, :receiver => user.id, :opened => false)
		message.procti_spravu(user.id)

		expect(Conversation.find(conversation.id).opened).to eq(true)
		message.procti_spravu(5)
		expect(Conversation.find(conversation2.id).opened).to eq(false)
	end

	it "Should check if message was opened" do
		user  = create(:user, :nick => "opica")
		message = create(:message)
	  create(:conversation, :message_id => message.id, :receiver => user.id, :opened => false)
		message1 = create(:message)
		create(:conversation, :message_id => message1.id, :receiver => user.id)
		message2 = create(:message)
		create(:conversation, :message_id => message2.id, :receiver => user.id, :opened => true)
		message3 = create(:message)
		create(:conversation, :message_id => message3.id)

		expect(message.proctena(user)).to eq(false)
		expect(message1.proctena(user)).to eq(false)
		expect(message2.proctena(user)).to eq(true)
		expect(message3.proctena(user)).to eq(false)
	end

	it "Should delete the message" do
		user  = create(:user)
		user2  = create(:user)
		message = create(:message)
		converssation = create(:conversation, :message_id => message.id, :sender => user.id, :receiver => user2.id, :deleted_by => nil)

		message.vymaz(user.id,true)

		expect(Conversation.find(converssation.id).deleted_by).to eq("S")

		message.vymaz(user2.id,false)
		expect(Conversation.find(converssation.id).deleted_by).to eq("SR")

	end

	it "Should send the messages" do
		house = create(:house)
		user  = create(:user, :house => house, :nick => "minohimself")

		user2  = create(:user, :house => house, :nick => "doktor")
		komu = "minohimself, doktor"
		message = create(:message, :user_id => 5)

		message.posli_postu(user,komu)

		expect(Conversation.where(:id => 1).exists?).to eq(true)
		expect(Conversation.where(:id => 2).exists?).to eq(true)
		expect(Conversation.where(:id => 3).exists?).to eq(false)
		expect(Conversation.where(:message_id => message.id, :receiver => user.id).exists?).to eq(true)
		expect(Conversation.where(:message_id => message.id, :receiver => user2.id).exists?).to eq(true)
		expect(Conversation.find(1).message_id).to eq(message.id)
		expect(Conversation.find(2).message_id).to eq(message.id)
		expect(Conversation.find(1).sender).to eq(message.user_id)
		expect(Conversation.find(2).sender).to eq(message.user_id)

		user1  = create(:user, :house => house, :nick => "simi")
		message2 = create(:message, :druh => "N")
		message2.posli_postu(user2,"")
		expect(Conversation.where(:message_id => message2.id, :receiver => user.id).exists?).to eq(true)
		expect(Conversation.where(:message_id => message2.id, :receiver => user1.id).exists?).to eq(true)
		expect(Conversation.where(:message_id => message2.id, :receiver => user2.id).exists?).to eq(true)
		expect(Conversation.where(:message_id => message.id, :receiver => user1.id).exists?).to eq(false)
	end


end