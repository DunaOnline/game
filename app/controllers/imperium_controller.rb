# encoding: utf-8
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
    if @spravce
      @melange = @leno.vynos('melange')
    else
      @melange = 0.0
    end
    @gilde = Prepocet.melanz_gilde(@melange)
    @operations = Operation.imperialni.seradit.limit(5)
  end

  def posli_imperialni_suroviny
    rod = House.imperium
    msg = ''
    unless params[:rod_id_suroviny] == ""
	    rodu = House.find(params[:rod_id_suroviny])
	    sol = params[:rodu_solary].to_i.abs
	    mel = params[:rodu_melanz].to_f.abs

	    if sol > 0 || mel > 0
		    msg << "Rodu #{rodu.name} poslano "

		    if sol <= rod.solar
		      rod.update_attribute(:solar, rod.solar - sol)
		      rodu.update_attribute(:solar, rodu.solar + sol)
		      msg << " #{sol} S "
		    else
			    msg << " #{rod.solar} S,"
			    rodu.update_attribute(:solar, rodu.solar + rod.solar)
			    rod.update_attribute(:solar, rod.solar - rod.solar)
		    end
		    if mel <= rod.melange
		      rod.update_attribute(:melange, rod.melange - mel)
		      rodu.update_attribute(:melange, rodu.melange + mel)
		      msg << " #{mel} mg melanze "
		    else
			    msg << " #{rod.melange} mg"
			    rodu.update_attribute(:melange, rodu.melange + rod.melange)
			    rod.update_attribute(:melange, rod.melange - rod.melange)
		    end

		    flash[:notice] = msg
		    Imperium.zapis_operaci(msg + " hracem #{current_user.nick}.")
		    rodu.zapis_operaci(msg.gsub("Rodu #{rodu.name} poslano ", "Obdrzeno z imperialni pokladny ") + " od hrace #{current_user.nick}.")
		    redirect_to sprava_imperia_path
	    else
		    flash[:alert] = "Nemuzes posilat nulu."
		    redirect_to sprava_imperia_path
	    end

    else
	    flash[:alert] = "Nesvolil jste si národ."
	    redirect_to sprava_imperia_path
	  end
  end
end