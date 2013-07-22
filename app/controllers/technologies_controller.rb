class TechnologiesController < ApplicationController
  # GET /technologies
  # GET /technologies.json
  def index
    @technologies = Technology.includes(:researches).where(:technology_discovered => 1)
    
  

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @technologies }
    end
  end

  # GET /technologies/1
  # GET /technologies/1.json
  def show
    @technology = Technology.find(params[:id])
     respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @technology }
    end
  end

  # GET /technologies/new
  # GET /technologies/new.json
  def new
    @technology = Technology.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @technology }
    end
  end

  # GET /technologies/1/edit
  def edit
    @technology = Technology.find(params[:id])

  end

  def vylepsi_technology
    @technologies = Technology.all
    @technology = Technology.find(params[:technology])
    @vylepseno = @technology.vylepseno(current_user)

    cena_tech = @technology.cena_technology(current_user)
    if @technology.vylepseno(current_user) == @technology.max_lvl
      flash[:error] = "Vyzkum na nejvissi urovni"
      redirect_to :action => 'index'
    else
      if cena_tech > current_user.exp
        flash[:error] = "Nedostatok zkusenosti pro vynalezeni, potreba #{(cena_tech - current_user.exp).round(0)} exp."
        redirect_to :action => 'index'
      else
        @technology.vylepsi(current_user)
        current_user.update_attributes(:exp => (current_user.exp - cena_tech))
        flash[:notice] = "Vyzkum byl vynalezen ."
        redirect_to :action => 'index'
      end
    end
  end
  

  # POST /technologies
  # POST /technologies.json
  def create
    @technology = Technology.find(params[:technology])
    


    respond_to do |format|
      if @technology.save
        format.html { redirect_to @technology, notice: 'Technology was successfully created.' }
        format.json { render json: @technology, status: :created, location: @technology }
      else
        format.html { render action: "new" }
        format.json { render json: @technology.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /technologies/1
  # PUT /technologies/1.json
  

  def update
    @technology = Technology.find(params[:id])
    
    #respond_with @technology
    respond_to do |format|
      if @technology.update_attributes(params[:technology])
        format.html { redirect_to @technology, notice: 'Research was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @technology.errors, status: :unprocessable_entity }
      end
    end
    
  end

  # DELETE /technologies/1
  # DELETE /technologies/1.json
  def destroy
    @technology = Technology.find(params[:id])
    @technology.destroy

    respond_to do |format|
      format.html { redirect_to technologies_url }
      format.json { head :no_content }
    end
  end
end
