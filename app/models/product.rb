class Product < ActiveRecord::Base
  attr_accessible :id, :parts, :title, :description, :material, :melanz, :price, :druh


  def vlastnim(leno)

	  produkty = leno.resource.productions.where(:product_id => self.id).first
	  if produkty
	  mnozstvo = produkty.amount
	  else
		mnozstvo = 0
		end
  end

  scope :zakladni, where(:druh => "D")
end
