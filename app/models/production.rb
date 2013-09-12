class Production < ActiveRecord::Base
  attr_accessible :resource_id, :user_id, :product_id, :amount

	belongs_to :user
  belongs_to :resource
	has_many :products

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





end
