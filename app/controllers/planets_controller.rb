# encoding: utf-8
class PlanetsController < ApplicationController
  authorize_resource # CanCan
  
  def index
    @planets = Planet.osidlitelna.or.viditelna(current_user.house).order(:name).all
  end

  def show
    @planet = Planet.find(params[:id])
    @fields = @planet.fields
    @cena_noveho_lena_melanz = @planet.cena_noveho_lena_mel
    @cena_noveho_lena_solary = @planet.cena_noveho_lena_sol
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
      redirect_to @planet, :notice  => "Successfully updated planet."
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
    @planets = Planet.osidlitelna.or.viditelna(current_user.house).order(:name).all
    render :index
  end
  
  def osidlit_pole
    @planet = Planet.find(params[:id])

    if @planet.osidlitelna?(current_user)
      cena_mel = params[:cena_mel].to_f
      cena_spoctena = @planet.cena_noveho_lena_mel.to_f
      cena_mel = cena_spoctena if cena_spoctena > cena_mel

      cena_sol = params[:cena_sol].to_f
      cena_spoctena = @planet.cena_noveho_lena_sol.to_f
      cena_sol = cena_spoctena if cena_spoctena > cena_sol

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
    @arrakis = Planet.arrakis
    @arrakis_field = Field.find_by_planet_id(@arrakis)
    @arrakis_resource = @arrakis_field.resource
    @arraken = Building.where(:name => "Arraken", :level => [1]).first
    @harvester = Building.where(:kind => "J", :level => [1]).first
  end
end
