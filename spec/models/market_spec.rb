require 'spec_helper'

describe Market do
	it "shows area of sold goods" do
		market  = create(:market, :area => "M", :price => 3, :amount => 10, :user_id => 5)
		pp = market.show_area

		expect(pp).to eq("Material")
	end
	it "update market with seller" do
		market  = create(:market, :area => "M", :price => 3, :amount => 10)
		pp = market.seller(5)

		expect(market.user_id).to eq(5)
	end
	#malo by sa otestovat vsetko co sa da predat ale na material a melanz by trebalo vytvorit resource a vazby na usera :D
	it "should update users resources after sell" do
		user  = create(:user, :exp => 4000)
		market  = create(:market, :area => "E", :price => 3, :amount => 10)
		pp = market.sell_goods(user)

		expect(user.exp.to_s).to eq("3990.0")
	end
	it "should get more expensive" do
		market  = create(:market, :area => "M", :price => 10, :amount => 10)
		market.expensive

		expect(market.price).to eq(11)
	end
	it "should get cheaper" do
		market  = create(:market, :area => "M", :price => 10, :amount => 10)
		market.discount

		expect(market.price).to eq(9)
	end
	#nemozem otestovat ci predajca dostal peniaze, podla mna to nefunguje lebo tu nemam relationship v metode volam self.user
	it "should update users resources after buy" do
		user  = create(:user)
		user2 = create(:user, :solar => 20000)
		market  = create(:market, :area => "E", :price => 3, :amount => 500, :user_id => 1)
		pp = market.buy_goods(400,user2)

		expect(user2.solar.to_s).to eq("18800.0")
		expect(user2.exp.to_s).to eq("400.0")
		expect(market.amount).to eq(100)
		#expect(user.solar.to_s).to eq("1200")
	end

end
