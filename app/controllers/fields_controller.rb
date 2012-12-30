# encoding: utf-8
class FieldsController < ApplicationController
  authorize_resource # CanCan
  
  def index
    @planets = current_user.osidlene_planety
    @domovska = Planet.domovska(current_user).first
    @pole_domovska = @domovska.fields.vlastnik(current_user).first
  end

  def show
    @field = Field.find(params[:id])
    @owner = @field.user
    if current_user.admin?
      
    else
      if @owner == current_user
        
      else
        redirect_to current_user
      end
    end
    @planet = @field.planet
    @resource = @field.resource
    @co_poslat = [["Materiál","Material"],["Populace","Population"]]
    @my_fields = current_user.fields
  end

  def new
    @field = Field.new
  end

  def create
    @field = Field.new(params[:field])
    if @field.save
      redirect_to @field, :notice => "Successfully created field."
    else
      render :action => 'new'
    end
  end

  def edit
    @field = Field.find(params[:id])
  end

  respond_to :html, :json
  def update
    #@field = Field.find(params[:id])
    #if @field.update_attributes(params[:field])
    #  redirect_to @field, :notice  => "Successfully updated field."
    #else
    #  render :action => 'edit'
    #end
    @field = Field.find(params[:id])
    @field.update_attributes(params[:field])
    respond_with @field
  end

  def destroy
    @field = Field.find(params[:id])
    @field.destroy
    redirect_to fields_url, :notice => "Successfully destroyed field."
  end
  
  def prejmenuj_pole
    @field = Field.find(params[:id])
    if @field.update_attribute(:name, params[:jmeno_pole])
      redirect_to @field, :notice  => "Pole prejmenovano."
    else
      render :action => 'prejmenuj_pole'
    end
  end
  
  def postavit_budovu
    @field = Field.find(params[:field])
    @resource = @field.resource
    @budova = Building.find(params[:budova])
    
    cena_sol = @budova.naklady_stavba_solary.to_f
    cena_mat = @budova.naklady_stavba_material.to_f
    mat_na_poli = @resource.material
    pocet_budov = params[:pocet_budov_stavba].to_i
    
    if cena_sol * pocet_budov > current_user.solar
      flash[:error] = "Nedostatek Solaru (chybi #{cena_sol * pocet_budov - current_user.solar} S)."
      redirect_to @field
    elsif cena_mat * pocet_budov > mat_na_poli
      flash[:error] = "Nedostatek materialu (chybi #{cena_mat * pocet_budov - mat_na_poli} kg)."
      redirect_to @field
    else
      if pocet_budov > 0
        if pocet_budov > @field.volne_misto
          flash[:error] = "Tolik budov nelze postavit."
          redirect_to @field
        else
          current_user.update_attribute(:solar, current_user.solar - (cena_sol * pocet_budov))
          @resource.update_attribute(:material, mat_na_poli - (cena_mat * pocet_budov))
          @field.postav(@budova, pocet_budov)
          redirect_to @field#, :notice => notice
        end
      else
        if pocet_budov.abs > @field.postaveno(@budova)
          flash[:error] = "Tolik budov nelze prodat."
          redirect_to @field
        else
          current_user.update_attribute(:solar, current_user.solar + ((cena_sol / 2) * pocet_budov.abs))
          @resource.update_attribute(:material, mat_na_poli + ((cena_mat / 2) * pocet_budov.abs))
          @field.postav(@budova, pocet_budov)
          redirect_to @field#, :notice => notice
        end
      end
      
    end
  end
  
  def postavit_arrakis
    @spravce = User.spravce_arrakis
    if @spravce == current_user
      @arrakis = Planet.arrakis
      @arrakis_field = Field.find_by_planet_id(@arrakis)
      @arrakis_resource = @arrakis_field.resource
      #@arraken = Building.where(:kind => "A", :level => [1]).first
      @harvester = Building.where(:kind => "J", :level => [1]).first
    
      #@field = Field.find(params[:field])
      #@budova = Building.find(params[:budova])
    
      cena_sol = @harvester.naklady_stavba_solary.to_f
      cena_mat = @harvester.naklady_stavba_material.to_f
      mat_na_poli = @arrakis_resource.material
      pocet_budov = params[:pocet_budov_stavba].to_i
    
      if cena_sol > current_user.solar
        flash[:error] = "Nedostatek Solaru (chybi #{cena_sol * pocet_budov - current_user.solar} S)."
        redirect_to zobraz_arrakis_path
      elsif cena_mat > mat_na_poli
        flash[:error] = "Nedostatek materialu (chybi #{cena_mat * pocet_budov - mat_na_poli} kg)."
        redirect_to zobraz_arrakis_path
      else
        if pocet_budov > 0
          # TODO mozna zrusit... tezit se muze jak chce ale poleze nespkojenost fremenu a utoky cervu...
          if pocet_budov > @arrakis_field.volne_misto
            flash[:error] = "Tolik budov nelze postavit."
            redirect_to zobraz_arrakis_path
          else
            current_user.update_attribute(:solar, current_user.solar - (cena_sol * pocet_budov))
            @arrakis_resource.update_attribute(:material, mat_na_poli - (cena_mat * pocet_budov))
            @arrakis_field.postav(@harvester, pocet_budov)
            redirect_to zobraz_arrakis_path
          end
        else
          if pocet_budov.abs > @field.postaveno(@harvester)
            flash[:error] = "Tolik budov nelze prodat."
            redirect_to zobraz_arrakis_path
          else
            current_user.update_attribute(:solar, current_user.solar + ((cena_sol / 2) * pocet_budov))
            @arrakis_resource.update_attribute(:material, mat_na_poli + ((cena_mat / 2) * pocet_budov))
            @arrakis_field.postav(@harvester, pocet_budov)
            redirect_to zobraz_arrakis_path
          end
        end
      end
    else
      redirect @arrakis
    end
    
  end

  def presun_suroviny
    source = Field.find(params[:source_field])
    redirect_to source
  end
  
end
