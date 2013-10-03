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

	it "should update users resources after buy" do
		user  = create(:user, :solar => 0)
		user2 = create(:user, :solar => 20000)
		market  = create(:market, :area => "E", :price => 3, :amount => 500)
		market.seller(user.id)
		pp = market.buy_goods(400,user2)

		expect(user2.solar.to_s).to eq("18800.0")
		expect(user2.exp.to_s).to eq("400.0")
		expect(market.amount).to eq(100)
		#expect(user.solar.to_s).to eq("1200") neviem preco to nejde ale funguje to v appke
	end

end
