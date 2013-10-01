# encoding: utf-8
class HousesController < ApplicationController
  #authorize_resource # CanCan

  def index
    @houses = House.playable.order(:name)
    @rody = @houses
  end

  def show
    if params[:id] == 1 or params[:id] == 2 or params[:id] == 3 # nezobrazime Titany, Imperium a Renegaty
      if current_user.admin?
        @house = House.find(params[:id]) # pouze adminum
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
        Imperium.zapis_operaci("Procentualni podil zisku melanze zmenen z #{melange_percent} na novou hodnotu #{@house.melange_percent}. #{current_user.nick}")
      end
      redirect_to @house, :notice => "Successfully updated house."
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
    if params[:commit]
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
    @productions = @house.productions
    @vudce = @house.vudce
    @mentate = @house.mentate
    @army_mentate = @house.army_mentate
    @diplomate = @house.diplomate
    @poslanci = @house.poslanci
    @generalove = @house.generalove
    @hraci = @house.users.order(:nick)
    @ziadosti = User.ziadost(@house.id)
    @user = current_user
    @markets = Market.zobraz_trh_house(@house)
    @market = Market.new
  end

  def send_products_house
    amount = params[:amount]
    production = Production.find(params[:production])
    msg, flag = current_user.house.move_product_house(production, amount.to_i)
    if flag
      redirect_to :back, :notice => "Vyrobky poslane"
    else
      redirect_to :back, :alert => msg
    end
  end

  def sell_products
    amount = params[:amount]

    if flag
      redirect_to :back, :notice => "Vyrobky poslane"
    else
      redirect_to :back, :alert => msg
    end
  end

  def prijmi_hrace
    user = User.find(params[:id])
    if user.prijat_do_naroda(current_user.house)
      current_user.house.zapis_operaci("Byl prijat novy hrac #{user.nick}", "N")
      redirect_to :back, :notice => "Hrac #{user.nick} bol prijaty do naroda"
    else
      redirect_to :back, :alert => "Nepodarilo sa prijat hraca"
    end

  end

  def posli_rodove_suroviny
    rod = current_user.house
    user = []
    mr = []
    narod = []
    rodu = params[:rod_id_suroviny]
    useru = params[:user_id_suroviny]
    mrdu = params[:mr_id_suroviny]
    user << params[:user_solary].to_f << params[:user_melanz].to_f << params[:user_zkusenosti].to_i << params[:user_material].to_f << params[:user_parts].to_f
    narod << params[:rodu_solary].to_f << params[:rodu_melanz].to_f << params[:rodu_zkusenosti].to_i << params[:rodu_material].to_f << params[:rodu_parts].to_f
    mr << params[:mr_solary].to_f << params[:mr_melanz].to_f << params[:mr_zkusenosti].to_i << params[:mr_material].to_f << params[:mr_parts].to_f
    msg, flag = rod.posli_rodove_suroviny(narod, user, mr, rodu, useru, mrdu)
    if flag
      redirect_to sprava_rod_path(:id => rod), :notice => msg
    else

      msg += "Nezadali ste mnozstvo na presun" if msg == ""
      redirect_to sprava_rod_path(:id => rod), :alert => msg
    end
  end

end
