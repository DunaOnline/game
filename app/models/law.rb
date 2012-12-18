# encoding: utf-8
# == Schema Information
#
# Table name: laws
#
#  id         :integer          not null, primary key
#  label      :string(255)      not null
#  title      :string(255)      not null
#  content    :text
#  state      :string(255)      not null
#  position   :integer
#  submitter  :integer          not null
#  submitted  :datetime
#  enacted    :datetime
#  signed     :datetime
#  created_at :datetime
#  updated_at :datetime
#

class Law < ActiveRecord::Base
  attr_accessible :label, :title, :content, :state, :position, :submitter, :submitted, :enacted, :signed 
  
  has_many :polls
  has_many :users, :through => :polls
  
  has_many :submitters, :class_name => 'User', :primary_key => :submitter, :foreign_key => :id
  
  STATE = [
    'Zarazen',
    'Projednavan',
    'Schvalen',
    'Zamitnut',
    'Podepsan'
  ]
  
  def self.create_label
    label = 'IZ' + Aplikace::VEK + '-'
    cislo = (Law.count + 1).to_s
    until cislo.length == 5
      cislo.insert(0, '0')
    end
    label += cislo
    return label
  end
  
  def self.create_position
    max_pos = Law.zarazene.maximum(:position).to_i
    max_pos += 1
    return max_pos
  end
  
  def vyhodnot_zakon
    hlasy_pro = self.polls.pro
    hlasy_proti = self.polls.proti
    zdrzelo_se = self.polls.zdrzelo
    
    celkem = hlasy_pro + hlasy_proti + zdrzelo_se
    
    if hlasy_pro > hlasy_proti && hlasy_pro > (0.5 * celkem)
      self.update_attribute(:state, Law::STATE[2])
      Landsraad.zapis_operaci("Byl schvalen zakon #{self.label} - #{self.title} pomerem: #{self.pomer_hlasu}.")
    else
      self.update_attribute(:state, Law::STATE[3])
      Landsraad.zapis_operaci("Zakon #{self.label} - #{self.title} byl zamitnut pomerem: #{self.pomer_hlasu}.")
    end
    
  end
  
  def pomer_hlasu
    pro = self.polls.pro.count
    proti = self.polls.proti.count
    zdrzelo = self.polls.zdrzelo.count
    
    return pro.to_s + '/' + proti.to_s + ' (' + zdrzelo.to_s + ')'
    
  end
  
  scope :zarazene, where(:state => Law::STATE[0])
  scope :projednavane, where(:state => Law::STATE[1])
  scope :schvalene, where(:state => Law::STATE[2])
  scope :zamitnute, where(:state => Law::STATE[3])
  scope :podepsane, where(:state => Law::STATE[4])
  
  scope :submited, lambda { |user| where(:submitter => user.id)}
  
  scope :seradit, order(:position, :submitted, :enacted, :signed).includes(:users)
end
