# == Schema Information
#
# Table name: systems
#
#  id          :integer          not null, primary key
#  system_name :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#

class System < ActiveRecord::Base
  attr_accessible :system_name

  has_many :planets, :primary_key => 'system_name', :foreign_key => 'system_name'

  def pocet_objevenych_planet
    self.planets.count
  end

  def zastoupene_rody
    # TODO silene!!!! predelat!!!!
    #max_poli = 0
    #for house in House.all do
    #  poli = house.fields.where(:planet_id => self.planets).count
    #  if poli > max_poli
    #    max_poli = poli
    #    dom_rod = house
    #  end
    #end
    #return dom_rod
    a = []
    b = []
    if self.planets != []
	    for planet in self.planets do
		    x = planet.zastoupene_rody
		    a << x if x != []
	    end

	    puts 'zastoupene rody : ' << a.to_s

	    #for zastupce in a do
	    #
		   # if b.assoc(zastupce[0]) == nil
			 #   b << [zastupce[0], zastupce[1]]
		   # else
			 #   b.assoc(zastupce[0])[1] += zastupce[1]
		   # end
	    #
	    #end
	    a.each do |pl|
		    pl.sort_by { |x| x[1] }.reverse
	    end
	    #if a
	    # a.sort_by {|h| [ h[1],h[1] ]}
	    #end
	    return a
	  end
  end

  def dominantni_rod
	  x = self.zastoupene_rody
	  if x != [] && x
	    a = x
	    if a[0]
	      a[0][0][0]
	    else
	      ''
	    end

		end
  end
end
