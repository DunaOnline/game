class ImperiumController < ApplicationController
  def sprava
    @title = 'Sprava Imperia'
    @courtship = User.dvorane
    @veziri = User.veziri
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @imperium = House.imperium
    @houses = House.playable
    
    @arrakis = Planet.arrakis
    @leno = Field.find_by_planet_id(@arrakis)
    @spravce = User.spravce_arrakis
    if @spravce
      @melange = @leno.vynos('melange')
    else
      @melange = 0.0
    end
    @gilde = Prepocet.melanz_gilde(@melange)
    @operations = Operation.imperialni.seradit.limit(5)
    @hraci = User.order(:nick)
  end
  
  def show
    @title = 'Imperium'
    @courtship = User.dvorane
    @veziri = User.veziri
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @imperium = House.imperium
    @houses = House.playable
    
    @arrakis = Planet.arrakis
    @leno = Field.find_by_planet_id(@arrakis)
    @spravce = User.spravce_arrakis
    if @spravce
      @melange = @leno.vynos('melange')
    else
      @melange = 0.0
    end
    @gilde = Prepocet.melanz_gilde(@melange)
    @operations = Operation.imperialni.seradit.limit(5)
  end
  
  
end