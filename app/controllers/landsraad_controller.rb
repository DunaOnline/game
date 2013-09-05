# encoding: utf-8
class LandsraadController < ApplicationController
  def show
    @title = 'Zasedání Landsraadu'
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @poslanci = User.poslanci

    @projednavane = Law.projednavane.order(:submitted, :position)
    @zarazeny = Law.zarazene.order(:submitted, :position)
    @zakony = Law.order(:submitted, :position)

  end

  def jednani

    @title = 'Jedání Landsraadu'
    @spravce = User.spravce_arrakis
    @imperator = User.imperator
    @poslanci = User.poslanci

    @datum_volby = Constant.konec_volby_imperatora

    @projednavane = Law.projednavane.order(:submitted, :position)
    @zarazeny = Law.zarazene.order(:submitted, :position)
    #@zakony = Law.order(:submitted, :position)

    @law = Law.new

	  @hlas = Poll.new




  end

  def imperator_zakony
	   @schvalene = Law.schvalene.order(:enacted, :position).where(:signed => nil)
	   @projednavane = Law.projednavane.order(:submitted, :position)
	   @videne = Law.order(:position).where(:signed => [true,false])

  end

  def podepisat_zakon
	  volba = params[:commit]
	  zakon = Law.find(params[:law_id])

	  if zakon.imp_podepis(volba,current_user)
	     redirect_to imperator_zakony_path
		end
  end


  def volba_imperatora
    # if params[:volit_id]
      # ja = User.find(params[:user_id])
      # if ja == current_user && ja.ladsraad? && Imperium.volba_imperatora?
        # koho = User.find(params[:volit_id])
        # ja.vol_imperatora(koho)
# 
        # redirect_to :back, :notice => "Uspesne odhlasovano."
      # else
        # redirect_to :back, :notice => "Nelze hlasovat."
      # end
    # else
      @title = 'Volba Imperatora'
      @spravce = User.spravce_arrakis
      
      @poslanci = User.poslanci
      
      @user = current_user
      @imperium = House.imperium
      @kandidati = User.players.by_nick
      
    # end
  end
end