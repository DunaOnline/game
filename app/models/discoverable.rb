# == Schema Information
#
# Table name: discoverables
#
#  id             :integer          not null, primary key
#  name           :string(255)      not null
#  planet_type_id :integer          not null
#  system_name    :string(255)      default("")
#  position       :integer
#  discovered     :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#

class Discoverable < ActiveRecord::Base
  attr_accessible :name, :planet_type_id, :system_name, :discovered, :position

  #belongs_to :planet_type
  before_create :vytvor_system
  
  def vytvor_system
    unless System.find_by_system_name(self.system_name)
      System.new(:system_name => self.system_name).save
    end
  end
  
  def zkolonizuj
    self.update_attribute(:discovered, true)
  end
  
  scope :kolonizovatelna, where(:discovered => false)
  
end
