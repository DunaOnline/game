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
end
