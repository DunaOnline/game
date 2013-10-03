require "spec_helper"

describe Production do

	#it "Should produce Products" do
	#	user = create(:user, :melange => 5, :solar => 5000)
	#	vyrobky = [[1,"opica"],[2,"ufon"]]
	#	vyrobok1 = create(:product, :title => "opica")
	#	vyrobok2 = create(:product, :title => "ufon")
	#	field = create(:field, :user_id => user.id)
	#
	#	production = Production.new
	#
	#	message, vyrobeno = production.vyroba_vyrobkov(vyrobky,field)
	#	#volakde tu je chyba ked dam ze vyrobok stoji nijake parts aj ked ich dam na resource tak to neprejde celkom haluz
	#	# a teraz je nastavene ze to stoji material user nema ziadny  ap prejde to
	#
	#	expect(vyrobeno).to eq(message)
	#	expect(Production.all.count).to eq(2)
	#	expect(message).to eq("")
	#
	#end
	#
	#it "Should produce Products" do
	#	production = create(:production)
	#	amount = 10
	#	field = create(:field)
	#	field1 = create(:field)
	#	building = create(:building)
	#	opica = production.check_availability(amount,field,production)
	#
	#
	#
	#	expect(opica).to eq("Nemate tolik vyrobku na presun")
	#	ufon = production.check_availability(5,field,production)
	#	expect(ufon).to eq(5)
	#
	# toto otestujem pri presune vyrobkov ked budem pisat test na field kde je presun
	#end
end