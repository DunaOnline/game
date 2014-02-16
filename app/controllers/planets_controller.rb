# encoding: utf-8
class PlanetsController < ApplicationController
  authorize_resource # CanCan

  def index
    @planets = Planet.osidlitelna.or.viditelna(current_user.house).order(:name).all
  end

  def show
    @planet = Planet.find(params[:id])
    if @planet == Arrakis.planeta
      return redirect_to zobraz_arrakis_path
    else
      @fields = @planet.fields
      tech_bonus = 2 - current_user.tech_bonus("J") #== 1 ? 0 : current_user.tech_bonus("J")
      nar_tech_bonus = 2 - current_user.house.vyskumane_narodni_tech("J")
      f_count = current_user.fields.count
      global_bonus = Constant.cena_noveho_lena * f_count
      @cena_noveho_lena_melanz = (@planet.cena_noveho_lena_mel * nar_tech_bonus * tech_bonus * global_bonus).round(2)
      @cena_noveho_lena_solary = (@planet.cena_noveho_lena_sol * nar_tech_bonus * tech_bonus * global_bonus).round(2)
      respond_to do |format|
	      format.html # show.html.erb
	      format.json { render json: @planet }
      end
    end
  end

  def new
    @planet = Planet.new
  end

  def create
    @planet = Planet.new(params[:planet])
    if @planet.save
      redirect_to @planet, :notice => "Successfully created planet."
    else
      render :action => 'new'
    end
  end

  def edit
    @planet = Planet.find(params[:id])
  end

  def update
    @planet = Planet.find(params[:id])
    if @planet.update_attributes(params[:planet])
      redirect_to @planet, :notice => "Successfully updated planet."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @planet = Planet.find(params[:id])
    @planet.destroy
    redirect_to planets_url, :notice => "Successfully destroyed planet."
  end

  def list_osidlitelnych
    #@planets = Planet.osidlitelna.or.viditelna(current_user.house).order(:name).all
    @planets = Planet.osidlitelna?(current_user).order(:name).all
    render :index
  end

  def osidlit_pole
    @planet = Planet.find(params[:id])
    tech_bonus = 2 - current_user.tech_bonus("J")
    nar_tech_bonus = 2 - current_user.house.vyskumane_narodni_tech("J")

    f_count = current_user.fields.count
    global_bonus = Constant.cena_noveho_lena * f_count
    if @planet.osidlitelna?(current_user)
      cena_mel = (@planet.cena_noveho_lena_mel * tech_bonus * nar_tech_bonus * global_bonus).round(2)
      cena_sol = (@planet.cena_noveho_lena_sol * tech_bonus * nar_tech_bonus * global_bonus).round(2)
      if cena_mel > current_user.melange
        flash[:error] = "Nedostatek melanze (chybi #{cena_mel - current_user.melange} mg)."
        redirect_to @planet
      elsif cena_sol > current_user.solar
        flash[:error] = "Nedostatek Solaru (chybi #{cena_sol - current_user.solar} S)."
        redirect_to @planet
      else
        field = @planet.vytvor_pole(current_user)
        field.save
        current_user.update_attributes(:melange => current_user.melange - cena_mel, :solar => current_user.solar - cena_sol)
        msg = "Uspesne osidleno (cena: #{cena_mel} mg melanze, #{cena_sol} Solaru)."
        current_user.zapis_operaci(msg)
        redirect_to field, :notice => msg
      end
    else
      redirect_to :back, :error => "Planetu #{@planet.name} nelze osídlit"
    end
  end

  def zobraz_arrakis
    @arrakis = Arrakis.planeta
    @arrakis_field = Field.find_by_planet_id(@arrakis)
    @arrakis_resource = @arrakis_field.resource
    @arraken = Building.where(:name => "Arraken", :level => [1]).first
    @harvester = Building.where(:kind => "J", :level => [1]).first
  end
end
