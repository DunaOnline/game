# encoding: utf-8
class LawsController < ApplicationController
  authorize_resource # CanCan

  # GET /laws
  # GET /laws.json
  def index
    if params[:zakony] == 'vsechny'
	    if params[:sort] == nil
		    @laws = Law.seradit.page(params[:page])
	    else
		    @laws = Law.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    elsif params[:zakony] == 'zarazene'
      if params[:sort] == nil
	      @laws = Law.zarazene.seradit.page(params[:page])
      else
	      @laws = Law.zarazene.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
      end
    elsif params[:zakony] == 'projednavane'
	    if params[:sort] == nil
		    @laws = Law.projednavane.seradit.page(params[:page])
	    else
		    @laws = Law.projednavane.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    elsif params[:zakony] == 'schvalene'
	    if params[:sort] == nil
		    @laws = Law.schvalene.seradit.page(params[:page])
	    else
		    @laws = Law.schvalene.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    elsif params[:zakony] == 'zamitnute'
	    if params[:sort] == nil
		    @laws = Law.zamitnute.seradit.page(params[:page])
	    else
		    @laws = Law.zamitnute.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    elsif params[:zakony] == 'podepsane'
	    if params[:sort] == nil
		    @laws = Law.podepsane.seradit.page(params[:page])
	    else
		    @laws = Law.podepsane.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    elsif params[:zakony] == 'platne'
	    if params[:sort] == nil
		    @laws = Law.platne.seradit.page(params[:page])
	    else
		    @laws = Law.platne.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    else
	    if params[:sort] == nil
		    @laws = Law.podepsane.seradit.page(params[:page])
	    else
		    @laws = Law.podepsane.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
	    end
    end
    if params[:sort] == nil
	  else
	    @laws = @laws.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
    end
    if params[:zakony]
      @title = params[:zakony].capitalize + ' zakony'
    else
      @title = 'Podepsane zakony'
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @laws }
    end
  end

  ## GET /laws/1
  ## GET /laws/1.json
  #def show
  #  @law = Law.find(params[:id])
  #
  #  respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @law }
  #  end
  #end
  #
  ## GET /laws/new
  ## GET /laws/new.json
  #def new
  #  @law = Law.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @law }
  #  end
  #end
  #
  ## GET /laws/1/edit
  #def edit
  #  @law = Law.find(params[:id])
  #end

  # POST /laws
  # POST /laws.json
  def create
    @law = Law.new(params[:law])

    actual = Law.projednavane.count

    @law.label = Law.create_label
    @law.position = Law.create_position
    @law.submitted = Time.now
    @law.state = Law::STATE[0]
    @law.submitter = current_user.id


    if @law.save
      flash[:notice] = "Zakon bol zaradeny na pojednavanie"
      redirect_to landsraad_jednani_path
      #format.html { redirect_to 'landsraad_jednani', notice: 'Law was successfully created.' }
      #format.json { render json: @law, status: :created, location: @law }
    else
      flash[:error] = "Titul aj telo zakona musi byt vyplnene"
      redirect_to landsraad_jednani_path
      #format.html { redirect_to 'landsraad_jednani', notice: 'Law was NOT successfully created.'  }
      #format.json { render json: @law.errors, status: :unprocessable_entity }

    end
  end

  # PUT /laws/1
  # PUT /laws/1.json
  def update
    @law = Law.find(params[:id])
    @law.state = Law::STATE[1]
    respond_to do |format|
      if @law.update_attributes(params[:law])
        format.html { redirect_to :back, notice: 'Law was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @law.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /laws/1
  # DELETE /laws/1.json
  #def destroy
  #  @law = Law.find(params[:id])
  #  @law.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to laws_url }
  #    format.json { head :ok }
  #  end
  #end

  #def hlasuj
  #
  #end
end
