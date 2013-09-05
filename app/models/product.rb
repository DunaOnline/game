class Product < ActiveRecord::Base
  attr_accessible :id, :example_value1, :example_value2, :parts, :title, :description, :material, :melanz, :price, :druh


  def vlastnim(user,leno)

	  produkty = user.productions.where(:product_id => self.id, :resource_id => leno).first
	  if produkty
	  mnozstvo = produkty.amount
	  else
		mnozstvo = 0
		end
  end

  scope :zakladni, where(:druh => "D")
end
