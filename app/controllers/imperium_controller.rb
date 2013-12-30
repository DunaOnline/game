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
    @regenti = User.regenti

    @arrakis = Arrakis.planeta
    @leno = Field.find_by_planet_id(@arrakis)
    if @spravce
      @melange = @leno.vynos('melange')
    else
      @melange = 0.0
    end
    @gilde = Prepocet.melanz_gilde(@melange)
    @operations = Operation.imperialni.seradit.limit(5)
    @hraci = User.order(:nick)
    @clenove_dvora = User.clenove_dvora


  end

  def show
    @title = 'Imperium'
    @courtship = User.dvorane
    @veziri = User.veziri
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @imperium = House.imperium
    @houses = House.playable
    @regenti = User.regenti

    @arrakis = Arrakis.planeta
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
    if params[:rod_id_suroviny] != ""
	    rodu = House.find(params[:rod_id_suroviny])
	    sol = params[:rodu_solary].to_i.abs
	    mel = params[:rodu_melanz].to_f.round(2).abs
	    mat = params[:rodu_material].to_f.round(2).abs

	    if sol > 0 || mel > 0 || mat > 0
		    msg << "Rodu #{rodu.name} poslano "

		    if sol <= rod.solar
		      rod.update_attribute(:solar, rod.solar - sol)
		      rodu.update_attribute(:solar, rodu.solar + sol)
		      msg << " #{sol} S, "
		    else
			    msg << " #{rod.solar} S,"
			    rodu.update_attribute(:solar, rodu.solar + rod.solar)
			    rod.update_attribute(:solar, rod.solar - rod.solar)
		    end
		    if mel <= rod.melange
		      rod.update_attribute(:melange, rod.melange - mel)
		      rodu.update_attribute(:melange, rodu.melange + mel)
		      msg << " #{mel} mg, "
		    else
			    msg << " #{rod.melange} mg, "
			    rodu.update_attribute(:melange, rodu.melange + rod.melange)
			    rod.update_attribute(:melange, rod.melange - rod.melange)
		    end
		    if mat <= rod.material
			    rod.update_attribute(:material, rod.material - mat)
			    rodu.update_attribute(:material, rodu.material + mat)
			    msg << " #{mat} kg."
		    else
			    msg << " #{rod.material} kg."
			    rodu.update_attribute(:material, rodu.material + rod.material)
			    rod.update_attribute(:material, rod.material - rod.material)
		    end

		    flash[:notice] = msg
		    Imperium.zapis_operaci(msg + " hracem #{current_user.nick}.")
		    rodu.zapis_operaci(msg.gsub("Rodu #{rodu.name} poslano ", "Obdrzeno z imperialni pokladny ") + " od hrace #{current_user.nick}.")
		    redirect_to sprava_imperia_path
	    else
		    flash[:alert] = "Nemuzes posilat nulu."
		    redirect_to sprava_imperia_path
	    end
    elsif params[:user_id_suroviny] != ""
	    hraci = User.find(params[:user_id_suroviny])
	    sol = params[:user_solary].to_i.abs
	    mel = params[:user_melanz].to_f.round(2).abs
	    mat = params[:user_material].to_f.round(2).abs

	    if sol > 0 || mel > 0 || mat > 0
		    msg << "Hraci #{hraci.nick} poslano "

		    if sol <= rod.solar
			    rod.update_attribute(:solar, rod.solar - sol)
			    hraci.update_attribute(:solar, hraci.solar + sol)
			    msg << " #{sol} S, "
		    else
			    msg << " #{rod.solar} S, "
			    hraci.update_attribute(:solar, hraci.solar + rod.solar)
			    rod.update_attribute(:solar, rod.solar - rod.solar)
		    end
		    if mel <= rod.melange
			    rod.update_attribute(:melange, rod.melange - mel)
			    hraci.update_attribute(:melange, hraci.melange + mel)
			    msg << " #{mel} mg, "
		    else
			    msg << " #{rod.melange} mg, "
			    hraci.update_attribute(:melange, hraci.melange + rod.melange)
			    rod.update_attribute(:melange, rod.melange - rod.melange)
		    end
		    if mat <= rod.material
			    rod.update_attribute(:material, rod.material - mat)
			    hraci.domovske_leno.resource.update_attribute(:material, hraci.domovske_leno.resource.material + mat)
			    msg << " #{mat} kg."
		    else
			    msg << " #{rod.material} kg."
			    hraci.domovske_leno.resource.update_attribute(:material, hraci.domovske_leno.resource.material + rod.material)
			    rod.update_attribute(:material, rod.material - rod.material)
		    end

		    flash[:notice] = msg
		    Imperium.zapis_operaci(msg + " hracem #{current_user.nick}.")
		    hraci.zapis_operaci(msg.gsub("Hraci #{hraci.nick} poslano ", "Obdrzeno z imperialni pokladny ") + " od hrace #{current_user.nick}.")
		    redirect_to sprava_imperia_path
	    else
		    flash[:alert] = "Nemuzes posilat nulu."
		    redirect_to sprava_imperia_path
	    end
    else
	    flash[:alert] = "Nesvolil jste si prijemce."
	    redirect_to sprava_imperia_path
	  end
  end
end