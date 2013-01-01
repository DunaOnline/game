# == Schema Information
#
# Table name: influences
#
#  id         :integer          not null, primary key
#  effect_id  :integer          not null
#  field_id   :integer          not null
#  started_at :date             default(Thu, 13 Dec 2012)
#  created_at :datetime
#  updated_at :datetime
#

class Influence < ActiveRecord::Base
end
