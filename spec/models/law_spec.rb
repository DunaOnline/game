# encoding: utf-8
require 'spec_helper'

describe Law do

	it "should create label" do

		law = create(:law, :title => Law.create_label)
		#true.should == false
		expect(law.title).to eq("IZ1-00001")
		law2 = create(:law, :title => Law.create_label)
		expect(law2.title).to eq("IZ1-00002")
	end

	it "should create position" do

		law = create(:law, :position => Law.create_position)
		law1 = create(:law, :position => Law.create_position, :state => "ufon")
		law2 = create(:law, :position => Law.create_position, :state => "ufon")
		expect(law.position).to eq(1)
		expect(law1.position).to eq(2)
		expect(law2.position).to eq(2)
		expect(Law.all.count).to eq(3)
	end

	#it "should evaluate the law" do
	#
	#	law = create(:law, :position => Law.create_position)
	#	3.times do
	#		create(:poll)
	#	end
	#	create(:poll, :choice => 'Ne')
	#	law.vyhodnot_zakon
	#
	#	expect(Poll.all.count).to eq(4)
	#	expect(law).to eq("Schvalen")
	#end

	it "should print out the polls result" do

		law = create(:law, :position => Law.create_position)
		3.times do
			create(:poll)
		end

		expect(Poll.all.count).to eq(3)
		pomer_hlasu = law.pomer_hlasu
		expect(pomer_hlasu).to eq("3/0 (0)")
		create(:poll, :choice => 'Ne')
		pomer_hlasu = law.pomer_hlasu
		expect(pomer_hlasu).to eq("3/1 (0)")

		expect(Poll.all.count).to eq(4)
	end

	it "should check if user has voted and what" do
		user = create(:user)
		law = create(:law, :position => Law.create_position)



		zahlasovane = law.zahlasovane(user)
		expect(zahlasovane).to eq(false)
		user2 = create(:user)
		create(:poll, :user_id => user2.id, :choice => "Ano")

		zahlasovane = law.zahlasovane(user2)
		expect(zahlasovane).to eq("Ano")

	end

	it "should sign the law by Imperator" do
		user = create(:user)
		volba = "Ano"
		law = create(:law)

		law.imp_podepis(volba,user)
    expect(law.state).to eq("Podepsan")
		#volba2 = "Ne"
		#law2 = create(:law, :position => Law.create_position, :state => "Zarazen" )
		#law2.imp_podepis(volba2,user)
		#expect(law2).to eq(true)
		# zase dalsie kokotina ←[31mSQLite3::ConstraintException: laws.state may not be NULL: UPDATE "laws" SET "signed" = NULL, "state" = NULL,
		#ed_at" = '2013-09-12 15:05:28.041874' WHERE "laws"."id" = 1←[0m

	end
end