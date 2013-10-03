# == Schema Information
#
# Table name: influences
#
#  id         :integer          not null, primary key
#  effect_id  :integer          not null
#  field_id   :integer          not null
#  duration   :integer          not null
#  started_at :date             default(Thu, 13 Dec 2012)
#  created_at :datetime
#  updated_at :datetime
#

class Influence < ActiveRecord::Base
  attr_accessible :effect_id, :field_id, :started_at, :duration

  belongs_to :field
  belongs_to :effect

  def odstran_katastrofu(user)
    if user.solar >= self.effect.price
      user.update_attribute(:solar, user.solar - self.effect.price * self.duration)
      self.destroy
      user.zapis_operaci("Odstranili sme katastrofu #{self.effect.name} na lenu #{self.field.name}, zaplatili sme #{self.effect.price * self.duration} .")
    end

  end
end
