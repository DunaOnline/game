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
    @hlas = Poll.new
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
    @zakon = params[:zakon]
	  @hlas = Poll.new




  end

  def vytvor_zakon
	  @law = Law.new(params[:law])

	  actual = Law.projednavane.count

	  @law.label = Law.create_label
	  @law.position = Law.create_position
	  @law.submitted = Time.now
	  if actual >= 3
	    @law.state = Law::STATE[0]
	  else
		  @law.state = Law::STATE[1]
		end
	  @law.submitter = current_user.id


	  if @law.save
		  flash[:notice] = "Zakon bol zaradeny na pojednavanie"
		  redirect_to :action => 'jednani'
	     #format.html { redirect_to 'landsraad_jednani', notice: 'Law was successfully created.' }
	     #format.json { render json: @law, status: :created, location: @law }
	  else
		  flash[:error] = "Titul aj telo zakona musi byt vyplnene"
		  redirect_to :action => 'jednani'
	     #format.html { redirect_to 'landsraad_jednani', notice: 'Law was NOT successfully created.'  }
	     #format.json { render json: @law.errors, status: :unprocessable_entity }

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
