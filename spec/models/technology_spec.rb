require "spec_helper"

describe Technology do

	it "should show price of technology" do
		user  = create(:user)
		technology  = create(:technology, :price => 400)
		pp = technology.cena_technology(user.id)

		expect(pp).to eq(400)
		#To change this template use File | Settings | File Templates.
		#true.should == false
	end

	it "should show price of house technology" do
		house  = create(:house)
		user  = create(:user, :house_id => house.id)
		technology  = create(:technology, :price => 400)
		pp = technology.cena_narodni_technology(house)

		expect(pp).to eq(400)

	end

	it "should increment price of house technology" do
		house  = create(:house)
		user  = create(:user, :house_id => house.id)
		create(:user, :house_id => house.id)
		technology  = create(:technology, :price => 400)
		technology.vylepsi_narodni(house.id)
		technology.vylepsi_narodni(house.id)
		vylepseno = technology.vylepseno_narodni(house.id)
		pp = technology.cena_narodni_technology(house)

		expect(pp).to eq(400 * ((vylepseno * 0.02)+1) * house.users.count)

	end

	it "should increment the price of technology" do
		user  = create(:user)
		technology  = create(:technology, :price => 400)
		technology.vylepsi(user)
		technology.vylepsi(user)
		vylepseno = technology.vylepseno(user.id)
		pp = technology.cena_technology(user.id)


		expect(pp).to eq(400*((vylepseno * 0.02)+1))
	end

end