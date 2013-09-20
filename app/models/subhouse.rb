# == Schema Information
#
# Table name: subhouses
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  house_id   :integer
#  solar      :integer
#  melange    :decimal(, )
#  material   :decimal(, )
#  exp        :integer
#  created_at :datetime
#  updated_at :datetime
#

class Subhouse < ActiveRecord::Base
  attr_accessible :name, :house_id, :solar, :melange, :material, :exp

  has_many :users

	def obsazenost_mr
		flag = true
		Subhouse.by_house(self.house_id).all.each do |subhouse|
			if subhouse.users.count > Constant.max_u_mr / 3
			flag = true
			else
			flag =	false
			end
		end
		flag
	end

  def prirad_mr(user)
	  user.update_attribute(:subhouse_id,self.id)
  end

  def pocet_userov
	  self.users.count
  end

  scope :by_house, lambda{ |house| where(house_id: house) unless house.nil? }

end
