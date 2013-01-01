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
end
