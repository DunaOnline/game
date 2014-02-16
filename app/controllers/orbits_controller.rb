class OrbitsController < ApplicationController
  # GET /orbits
  # GET /orbits.json
  def index
	  @title = 'Jednotky na orbite.'
	  @planet_with_orbits = current_user.planets_with_kosmodrom
	  @orbits = current_user.orbits
	  @ships = Ship.all
	  @orbit = Orbit.new
	  @user = current_user

	  if params[:planet]
		  planet = Planet.where(params[:planet]).first
		  @planet = planet if planet && planet.vlastni_pole(current_user)
	  end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orbits }
    end
  end

  def move_orbits

  end

  # GET /orbits/1
  # GET /orbits/1.json
  def show
	  @title = 'Verbovani vesmirnych jednotek.'
	  @planet_with_orbits = current_user.planets_with_kosmodrom
	  @user = current_user
	  @planet = Planet.find(params[:id])
    @orbit = Orbit.new
	  @ships = Ship.all
	  if @planet.vlastni_pole(current_user).first && @planet.kapacita_kosmodromu(@user) != 0

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orbit }
    end
	  else
		  redirect_to orbits_path, :alert => 'Nemate kosmodrom na teto plante.'
	  end
  end

  # GET /orbits/new
  # GET /orbits/new.json
  def new
    @orbit = Orbit.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orbit }
    end

  end

  # GET /orbits/1/edit
  def edit
    @orbit = Orbit.find(params[:id])
  end

  # POST /orbits
  # POST /orbits.json
  def create
	  par = []
    @orbit = Orbit.new(params[:orbit])
    lode = Ship.all.map { |x| x.name }
    @planet = Planet.find(params[:planet])
    lode.each do |title|
	    par << [([params[title]]), [title]] unless params[title] == ""
    end
    if params[:commit]
    msg, flag = @planet.verbovat_ship(par,current_user)
		  if flag
			  redirect_to orbit_path(@planet), :notice => msg
		  else
			  redirect_to :back, :alert => msg
	    end
	  elsif params[:zrusit]
	  msg, flag = @planet.sell_ship(par,current_user)
		  if flag
			  redirect_to orbit_path(@planet), :alert => msg
		  else
			  redirect_to :back, :alert => msg
		  end
    end
    #respond_to do |format|
    #  if @orbit.save
    #    format.html { redirect_to @orbit, notice: 'Orbit was successfully created.' }
    #    format.json { render json: @orbit, status: :created, location: @orbit }
    #  else
    #    format.html { render action: "new" }
    #    format.json { render json: @orbit.errors, status: :unprocessable_entity }
    #  end
    #end
  end

  def move_orbits
	  par = []
	  ships = Ship.all.map { |x| x.name }
	  source_planet = Planet.find(params[:planet])
	  target_planet = Planet.find(params[:planet_orbit])
	  if target_planet.kapacita_kosmodromu(current_user)
		  if source_planet.vlastni_pole(current_user) && target_planet.vlastni_pole(current_user)
			  ships.each do |title|
				  par << [([params[title]]), [title]] unless params[title] == nil || params[title] == "0" || params[title] == ""
			  end
			  if par.any?
				  done, msg = source_planet.move_units(target_field,par)
				  respond_to do |format|
					  if done
						  format.html { redirect_to squads_path(:leno => source_field.id), notice: msg }
						  format.json { render json: msg, status: :created, location: squad_path(source_field.id) }
					  else
						  format.html { redirect_to :back, alert: msg }
						  #format.json { render json: @unit.errors, status: :unprocessable_entity }
					  end
				  end
			  else
				  redirect_to :back, :alert => "Nezadali ste jednotky na presun."
			  end
		  else
			  redirect_to :back, :alert => 'Nemate orbitu na planete vam nepatri.'
		  end
	  else
		  redirect_to :back, :alert => 'Na tom lenu nemate kasaren.'
	  end
  end

  # PUT /orbits/1
  # PUT /orbits/1.json
  def update
    @orbit = Orbit.find(params[:id])

    respond_to do |format|
      if @orbit.update_attributes(params[:orbit])
        format.html { redirect_to @orbit, notice: 'Orbit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orbit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orbits/1
  # DELETE /orbits/1.json
  def destroy
    @orbit = Orbit.find(params[:id])
    @orbit.destroy

    respond_to do |format|
      format.html { redirect_to orbits_url }
      format.json { head :no_content }
    end
  end
end
