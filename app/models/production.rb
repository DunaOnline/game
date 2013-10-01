class Production < ActiveRecord::Base
  attr_accessible :resource_id, :user_id, :house_id, :subhouse_id, :product_id, :amount

  belongs_to :user
	belongs_to :house
  belongs_to :subhouse
  belongs_to :resource
	belongs_to :product

  #validates_presence_of :resource_id, :user_id, :product_id, :amount


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




	scope :active, where('amount > ?', 0)
end
