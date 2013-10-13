# == Schema Information
#
# Table name: environments
#
#  id          :integer          not null, primary key
#  planet_id   :integer          not null
#  property_id :integer          not null
#  started_at  :date             default(Thu, 13 Dec 2012)
#  created_at  :datetime
#  updated_at  :datetime
#

class Environment < ActiveRecord::Base

  belongs_to :planet
  belongs_to :property

  def odstran_katastrofu(user)
    if user.solar >= self.price
      user.update_attribute(:solar, user.solar - self.property.price * self.duration)
      self.destroy
      user.zapis_operaci("Odstranili sme katastrofu #{self.property.name} na planete #{self.planet.name}, zaplatili sme #{self.price} .")
    end

  end

  def price
	  (self.duration + 1) * self.property.price
  end
end
