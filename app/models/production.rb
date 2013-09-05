class Production < ActiveRecord::Base
  attr_accessible :resource_id, :user_id, :product_id, :amount

	belongs_to :user
  belongs_to :resource
	has_many :products

  #validates_presence_of :resource_id, :user_id, :product_id, :amount




	def vyroba_vyrobkov(vyrobky,user,field)
		field = Field.find(field)
		zdroje_lena = field.resource
		total_material = 0
		total_melanz = 0
		total_price = 0
		total_parts = 0
		vyrobeno = false

		vyrobky.each do |vyrobok|
			pocet = vyrobok[0]
			pocet = pocet[0].to_i
			coho = Product.where(:title => vyrobok[1]).first

			total_material += coho.material * pocet
			total_melanz += coho.melanz * pocet
			total_price += coho.price * pocet
			total_parts += coho.parts * pocet

		end
		material = zdroje_lena.material > total_material
		melanz = user.melange > total_melanz
		price = user.solar > total_price
		parts = zdroje_lena.parts > total_parts

		oznamenie = ""

		if material && melanz && price && parts
			vyrobky.each do |vyrobok|
				pocet = vyrobok[0]
				pocet = pocet[0].to_i
				coho = Product.where(:title => vyrobok[1]).first

				produkcia = Production.where(:user_id => user.id, :resource_id => zdroje_lena.id, :product_id => coho.id).first
				if produkcia
					 produkcia.update_attribute(:amount , produkcia.amount + pocet)
				else
				Production.new(
						:resource_id => zdroje_lena.id,
						:user_id => user.id,
						:product_id => coho.id,
						:amount => pocet
				).save
				end
			end

			zdroje_lena.update_attributes(:material => zdroje_lena.material - total_material, :parts => zdroje_lena.parts - total_parts)
			user.update_attributes(:solar => user.solar - total_price, :melange => user.melange - total_melanz)
			vyrobeno = true
		else
		oznamenie += "Chybi vam "
		oznamenie += (total_material - zdroje_lena.material).to_s + " kg materialu" unless material
		oznamenie += (total_melanz - user.melange).to_s + " mg melanze" unless melanz
		oznamenie += (total_parts - zdroje_lena.parts).to_s + " vyrobkov " unless parts
		oznamenie += (total_price - user.solar).to_s + " solaru " unless price
		oznamenie += "."
		end
		return oznamenie, vyrobeno
	end



  def check_availability(amount,target_field,target_production)
	  message = ""
	 if self.amount < amount
		 message += "Nemate tolik vyrobku na presun"
	 elsif target_production.amount + amount >= target_field.kapacita_tovaren
		 message += "Kapacita na cilovem lenu vam nedovoli presunout tolik vyrobku"
	 elsif self == target_production
		 message += "Nemuzes presouvat medzi stejnymi leny"
	 else
		 true
	 end
	end





end
