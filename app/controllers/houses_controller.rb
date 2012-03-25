class HousesController < ApplicationController
  #authorize_resource # CanCan
  
  def index
    @houses = House.all
  end

  def show
    if params[:id] == 1 or params[:id] == 2   # nezobrazime Titany a Renegaty
      if current_user.admin?
        @house = House.find(params[:id])      # pouze adminum
      else
        @house = current_user.house
      end
    else
      @house = House.find(params[:id])
    end
    @vudce = @house.vudce
    @mentate = @house.mentate
    @army_mentate = @house.army_mentate
    @diplomate = @house.diplomate
    @poslanci = @house.poslanci
    @generalove = @house.generalove
    @hraci = @house.users.order(:nick)
    @rody = House.playable.order(:name)
  end

  def new
    @house = House.new
  end

  def create
    @house = House.new(params[:house])
    if @house.save
      redirect_to @house, :notice => "Successfully created house."
    else
      render :action => 'new'
    end
  end

  def edit
    @house = House.find(params[:id])
  end

  def update
    @house = House.find(params[:id])
    if @house.update_attributes(params[:house])
      redirect_to @house, :notice  => "Successfully updated house."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @house = House.find(params[:id])
    @house.destroy
    redirect_to houses_url, :notice => "Successfully destroyed house."
  end
  
  def kolonizuj
    if params[:commit] == "Kolonizuj"
      house = House.find(params[:house])
      
      cena_mel = params[:cena_mel].to_f
      cena_spoctena = Vypocty.cena_nove_planety_melanz.to_f
      cena_mel = cena_spoctena if cena_spoctena > cena_mel 
    
      cena_sol = params[:cena_sol].to_f
      cena_spoctena = Vypocty.cena_nove_planety_solary.to_f
      cena_sol = cena_spoctena if cena_spoctena > cena_sol
      
      if cena_mel > house.melange
        flash[:error] = "Nedostatek melanze."
        redirect_to kolonizuj_path
      elsif cena_sol > house.solar
        flash[:error] = "Nedostatek Solaru."
        redirect_to kolonizuj_path
      else
        planeta = house.kolonizuj_planetu
        planeta.save
        house.update_attributes(:melange => house.melange - cena_mel, :solar => house.solar - cena_sol)
      end
      redirect_to planeta
    else
      @house = current_user.house
      @cena_planety_mel = Vypocty.cena_nove_planety_melanz
      @cena_planety_sol = Vypocty.cena_nove_planety_solary
    end
  end
  
  def sprava_rod
    if current_user.admin?
      @house = House.find(params[:id])
    else
      @house = current_user.house
    end
    @vudce = @house.vudce
    @mentate = @house.mentate
    @army_mentate = @house.army_mentate
    @diplomate = @house.diplomate
    @poslanci = @house.poslanci
    @generalove = @house.generalove
    @hraci = @house.users.order(:nick)
  end
end
