class HousesController < ApplicationController
  #authorize_resource # CanCan
  
  def index
    @houses = House.playable.order(:name)
  end

  def show
    if params[:id] == 1 or params[:id] == 2 or params[:id] == 3   # nezobrazime Titany, Imperium a Renegaty
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
    @operations = @house.operations.narodni.seradit.limit(5)
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
    melange_percent = @house.melange_percent
    if @house.update_attributes(params[:house])
      unless @house.melange_percent == melange_percent
        Imperium.zapis_operaci("Procentualni podil zisku melanze zmenen z #{melange_percent} na novou hodnotu #{@house.melange_percent}")
      end
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
        redirect_to planeta
      end
      
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
  
  def posli_rodove_suroviny
    rod = current_user.house
    
    msg = ''
    
    if params[:user_solary].to_i > 0.0 || params[:user_melanz].to_f > 0.0 || params[:user_zkusenosti].to_i > 0.0
      komu = User.find(params[:user_id_suroviny])
      msg << "Poslano hraci #{komu.nick} "
    end
    if params[:user_solary].to_i > 0.0 && params[:user_solary].to_i <= rod.solar
      rod.update_attribute(:solar, rod.solar - params[:user_solary].to_i)
      komu.update_attribute(:solar, komu.solar + params[:user_solary].to_i)
      msg << "solary: #{params[:user_solary]} "
    end
    if params[:user_melanz].to_f > 0.0 && params[:user_melanz].to_f <= rod.melange
      rod.update_attribute(:melange, rod.melange - params[:user_melanz].to_f)
      komu.update_attribute(:melange, komu.melange + params[:user_melanz].to_f)
      msg << "melanz: #{params[:user_melanz]} "
    end 
    if params[:user_zkusenosti].to_i > 0.0 && params[:user_zkusenosti].to_i <= rod.exp
      rod.update_attribute(:exp, rod.exp - params[:user_zkusenosti].to_i)
      komu.update_attribute(:exp, komu.exp + params[:user_zkusenosti].to_i)
      msg << "expy: #{params[:user_zkusenosti]} "
    end
    
    if params[:rodu_solary].to_i > 0.0 || params[:rodu_melanz].to_f > 0.0 || params[:rodu_zkusenosti].to_i > 0.0
      rodu = House.find(params[:rod_id_suroviny])
      msg << " Poslano rodu #{rodu.name} "
    end
    if params[:rodu_solary].to_i > 0.0 && params[:rodu_solary].to_i <= rod.solar
      rod.update_attribute(:solar, rod.solar - params[:rodu_solary].to_i)
      rodu.update_attribute(:solar, rodu.solar + params[:rodu_solary].to_i)
      msg << "solary: #{params[:rodu_solary]} "
    end
    if params[:rodu_melanz].to_f > 0.0 && params[:rodu_melanz].to_f <= rod.melange
      rod.update_attribute(:melange, rod.melange - params[:rodu_melanz].to_f)
      rodu.update_attribute(:melange, rodu.melange + params[:rodu_melanz].to_f)
      msg << "melanz: #{params[:rodu_melanz]} "
    end 
    if params[:rodu_zkusenosti].to_i > 0.0 && params[:rodu_zkusenosti].to_i <= rod.exp
      rod.update_attribute(:exp, rod.exp - params[:rodu_zkusenosti].to_i)
      rodu.update_attribute(:exp, rodu.exp + params[:rodu_zkusenosti].to_i)
      msg << "expy: #{params[:rodu_zkusenosti]} "
    end
    
    flash[:notice] = msg
    rod.zapis_operaci(msg + " hracem #{current_user.nick}.")
    current_user.zapis_operaci(msg.gsub("Poslano hraci #{komu.nick} ", "Obdrzeno "))
    redirect_to sprava_rod_path(:id => rod)
  end
end
