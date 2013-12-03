# encoding: utf-8
class FieldsController < ApplicationController
  authorize_resource # CanCan

  def index
    @planets = current_user.osidlene_planety
    @domovska = Planet.domovska(current_user).first
    @pole_domovska = @domovska.fields.vlastnik(current_user).first
    @co_poslat = [["Materiál", "Material"], ["Populace", "Population"], ["Vyrobky", "Parts"]]
    if current_user.arrakis
      @my_fields = current_user.fields << Arrakis.leno
    else
	    @my_fields = current_user.fields
    end
	  @exp_bonus = []
	  @effect_bonus = []
  end

  def show
    @field = Field.find_by_id(params[:id])
    if @field
      @owner = @field.user
      user_lvl = @owner.tech_bonus("L")
      house_lvl = @owner.house.vyskumane_narodni_tech("L")
      @bonus = 2 - (user_lvl * house_lvl).to_f

      if current_user.admin? || @owner == current_user

      else
        redirect_to field_url(current_user.domovske_leno)
      end

      @planet = @field.planet
      @resource = @field.resource
      @co_poslat = [["Materiál", "Material"], ["Populace", "Population"], ["Vyrobky", "Parts"]]
      @my_fields = current_user.fields
    else
      redirect_to field_url(current_user.domovske_leno)
    end
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
      redirect_to @field, :notice => "Pole prejmenovano."
    else
      render :action => 'prejmenuj_pole'
    end
  end

  def postavit_budovu
    @field = Field.find(params[:field])
    if @field.user == current_user || current_user.admin?
      @budova = Building.find(params[:budova])
      pocet_budov = params[:pocet_budov_stavba].to_i

      message, postaveno = @field.postav_availability_check(@budova, pocet_budov)
      respond_to do |format|
        if postaveno
          format.html { redirect_to @field, notice: message }
          format.json { render json: @budova, status: :created, location: @budova }
        else
          format.html { redirect_to @field, alert: message }
          format.json { render json: @budova, status: :created, location: @budova }
        end
      end
    else
      redirect_to :back, :error => "Na tomto poli nemůžeš stavět."
    end
  end

  def vylepsi_budovu
	  @field = Field.find(params[:field])
	  if @field.user == current_user || current_user.admin?
		  @budova = Building.find(params[:budova])
		  pocet_upg = params[:pocet_budov_vylepseni].to_i
		  if pocet_upg == 0
			  postaveno = false
			  message = "Nezadali jste mnozsti vylepseni"
		  else
			  if pocet_upg > 0
				  postaveno, message = @field.upgrade_availability_check(@budova, pocet_upg)
			  else
				  postaveno, message = @field.upgrade_sell_availability_check(@budova, pocet_upg.abs)
			  end
		  end


		  respond_to do |format|
			  if postaveno
				  format.html { redirect_to @field, notice: message }
				  format.json { render json: @budova, status: :created, location: @budova }
			  else
				  format.html { redirect_to @field, alert: message }
				  format.json { render json: @budova, status: :created, location: @budova }
			  end
		  end
	  else
		  redirect_to :back, :error => "Na tomto poli nemůžeš vylepšovat."
	  end
  end

  def postavit_arrakis
    @spravce = User.spravce_arrakis
    @arrakis = Arrakis.planeta
    if @spravce == current_user
      @arrakis_field = Arrakis.leno
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
          current_user.update_attribute(:solar, current_user.solar - (cena_sol * pocet_budov))
          @arrakis_resource.update_attribute(:material, mat_na_poli - (cena_mat * pocet_budov))
          @arrakis_field.postav(@harvester, pocet_budov)
          redirect_to zobraz_arrakis_path
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
      redirect_to @arrakis
    end

  end

  def presun_suroviny
    source = Field.find(params[:source_field])
    target = Field.find(params[:target_field])

    if (source.drzitel(current_user) && target.drzitel(current_user)) && (source != target)

      case str = source.move_resource(target, params[:presunout_co], params[:amount].to_i.abs, params[:tof])
        when true
          flash[:notice] = "Suroviny přesunuty."
          #if params[:tovarna]
          #  redirect_to productions_path
          #else
          redirect_to :back
        #end
        else
          flash[:error] = str
          #if params[:tovarna]
          # redirect_to productions_path
          #else
          redirect_to :back
        #end
      end
    else
	    if source == target
		    flash[:notice] = "Posielas na stejne leno."
	    else
		    flash[:error] = "Můžeš posílat jen mezi svými lény."
	    end


      if params[:tovarna]
        redirect_to productions_path
      else
        redirect_to :back
      end
    end

  end

end
