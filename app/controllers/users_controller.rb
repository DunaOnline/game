# encoding: utf-8
class UsersController < ApplicationController
#  authorize_resource # CanCan

  before_filter :login_required, :except => [:new, :create]

  def index
    @users = User.where(:house_id => House.playable).order(:nick).page(params[:page])
  end

  def new
    if Aplikace.zakladani_hracu_povoleno?
      @user = User.new
      @houses = House.playable.all
    else
      redirect_to root_url, :alert => "Zakladani uctu docasne zakazano."
    end
  end

  def show
    @user = User.find(params[:id])
    #@planets = @user.najdi_planety

  end

  def create
    @user = User.new(params[:user])
    if @user.save

      @planet = @user.house.planets.domovska(@user).first
      @planet.fields << @planet.vytvor_pole(@user)

      @user.hlasuj(@user, "leader")

      @user.napln_suroviny

      session[:user_id] = @user.id
      redirect_to @user, :notice => "Thank you for signing up! You are now logged in."
    else
      @houses = House.playable.all
      render :action => 'new'
    end
  end

  def edit
    @user = current_user
  end

  respond_to :html, :json

  def update
    #@user = current_user
    #if @user.update_attributes(params[:user])
    #  redirect_to root_url, :notice => "Your profile has been updated."
    #else
    #  render :action => 'edit'
    #end
    @user = current_user
    @user.update_attributes(params[:user])
    respond_with @user
  end

  def zmen_prava
    # asi presunout do admin_controller
    if params[:commit] == "Vyber"
      @user_prava = User.find(params[:user_id_prava])
    else
      @user_zmena = User.find(params[:user_id_zmena])
      @user_zmena.update_attributes(params[:user])
      @user_zmena.change_password(params[:new_password]) unless params[:new_password] == ""
      redirect_to @user_zmena
    end
  end

  def hlasovat
    ja = User.find(params[:user_id])
    koho = User.find(params[:volit_id])
    if params[:leader]
      ja.hlasuj(koho, 'leader')
    elsif params[:poslanec]
      ja.hlasuj(koho, 'poslanec')
    elsif params[:imperator]
      ja.vol_imperatora(koho)
    else

    end
    redirect_to :back, :notice => "Uspesne odhlasovano."
  end

  def sprava
    if current_user.admin?
      @user = User.find(params[:id])
    else
      @user = current_user
    end
    @planets = @user.najdi_planety
    @operations = @user.operations.uzivatelske.seradit.limit(5)

  end

  def udalosti
	  case params[:typ]
		  when "L"
			  @udalost = Influence.find(params[:id]).effect
			  @leno =  Influence.find(params[:id])
		  when "P"
			  @udalost = Environment.find(params[:id]).property
			  @planet =  Environment.find(params[:id])
		  else

	  end


  end

  def zrus_udalost
	  @udalost = Environment.find(params[:id])
  end

  def opustit

    if params[:id]
		  user = User.find(params[:id])
		  if user.domovske_leno.planet == Planet.domovska_rodu(House.renegat).first
			  redirect_to :back, :notice => "Nemozte opustit renegatov"
		  else
		  narod = user.house
		  user.opustit_narod


		  redirect_to :back, :notice => "Opustili ste narod #{narod.name}"
		  end
    else
	    redirect_to :back
	  end
  end

  def ziadost
	  if params[:id]
		  user = User.find(params[:id])

			  if msg = user.podat_ziadost(params[:narod])
				  redirect_to :back, :notice => msg
			  else
				  redirect_to :back, :alert => msg
			  end
	  else
		  redirect_to :back
		end
  end

  def oprava_katastrofy
	  if params[:typ] == "L"
		  effect = Influence.find(params[:id])
		  effect.odstran_katastrofu(current_user)
		  redirect_to sprava_path(:id => current_user)
	  elsif params[:typ] == "P"
		  enviro = Environment.find(params[:id])
		  enviro.odstran_katastrofu(current_user)
		  redirect_to sprava_path(:id => current_user)
	  else
		  redirect_to sprava_path(:id => current_user)
		end


  end

  def pridel_pravo
    komu = User.find(params[:user_id])
    case params[:commit]
      when "Mentat"
        komu.stat_se("mentat")
      when "ArmyMentat"
        komu.stat_se("army_mentat")
      when "Diplomat"
        komu.stat_se("diplomat")
      when "Dvoran"
        komu.stat_se("court")
        Imperium.zapis_operaci("#{current_user.nick} jmenoval hrace #{komu.nick} na pozici #{params[:commit]}.")
      when "Vezir"
        komu.stat_se("vezir")
        Imperium.zapis_operaci("#{current_user.nick} jmenoval hrace #{komu.nick} na pozici #{params[:commit]}.")

    end
    current_user.house.zapis_operaci("#{current_user.nick} jmenoval hrace #{komu.nick} na pozici #{params[:commit]}.")
    komu.zapis_operaci("#{current_user.nick} me jmenoval na pozici #{params[:commit]}.")
    redirect_to :back
  end

  def odeber_pravo
    komu = User.find(params[:user_id])
    case params[:pravo]
      when "Mentat"
        komu.prestat_byt("mentat")
      when "ArmyMentat"
        komu.prestat_byt("army_mentat")
      when "Diplomat"
        komu.prestat_byt("diplomat")
      when "Court"
        komu.prestat_byt("court")
        Imperium.zapis_operaci("#{current_user.nick} odvolal hrace #{komu.nick} z pozice Dvoran.")
      when "Vezir"
        komu.prestat_byt("vezir")
        Imperium.zapis_operaci("#{current_user.nick} odvolal hrace #{komu.nick} z pozice #{params[:pravo]}.")

    end
    current_user.house.zapis_operaci("#{current_user.nick} odvolal hrace #{komu.nick} z pozice #{params[:pravo]}.")
    komu.zapis_operaci("#{current_user.nick} me odvolal z pozice #{params[:pravo]}.")
    redirect_to :back
  end


  def posli_suroviny
    rod = current_user.house
    msg = "Poslano rodu #{rod.name} " if params[:rod_solary].to_i > 0.0 || params[:rod_melanz].to_f > 0.0 || params[:rod_zkusenosti].to_i > 0.0 || params[:rod_material].to_i > 0.0 || params[:rod_vyrobky].to_i > 0.0

    if params[:rod_solary].to_i > 0.0 && params[:rod_solary].to_i <= current_user.solar
      rod.update_attribute(:solar, rod.solar + params[:rod_solary].to_i)
      current_user.update_attribute(:solar, current_user.solar - params[:rod_solary].to_i)
      msg << "solary: #{params[:rod_solary]} "
    end
    if params[:rod_melanz].to_f > 0.0 && params[:rod_melanz].to_f <= current_user.melange
      rod.update_attribute(:melange, rod.melange + params[:rod_melanz].to_f)
      current_user.update_attribute(:melange, current_user.melange - params[:rod_melanz].to_f)
      msg << "melanz: #{params[:rod_melanz]} "
    end
    if params[:rod_zkusenosti].to_i > 0.0 && params[:rod_zkusenosti].to_i <= current_user.exp
      rod.update_attribute(:exp, rod.exp + params[:rod_zkusenosti].to_i)
      current_user.update_attribute(:exp, current_user.exp - params[:rod_zkusenosti].to_i)
      msg << "expy: #{params[:rod_zkusenosti]} "
    end

    leno = current_user.domovske_leno.resource
    if params[:rod_material].to_i > 0.0 && params[:rod_material].to_i <= leno.material
      rod.update_attribute(:material, rod.material - params[:rod_material].to_i)
      leno.update_attribute(:material, leno.material + params[:rod_material].to_i)
      msg << "materiál: #{params[:rod_material]} "
    end

    if params[:rod_vyrobky].to_i > 0.0 && params[:rod_vyrobky].to_i <= leno.parts
	    rod.update_attribute(:parts, rod.parts + params[:rod_vyrobky].to_i)
	    leno.update_attribute(:parts, leno.parts - params[:rod_vyrobky].to_i)
	    msg << "vyrobky: #{params[:rod_vyrobky]} "
    end

    current_user.zapis_operaci(msg)
    flash[:notice] = msg
    rod.zapis_operaci(msg.gsub("Poslano rodu #{rod.name} ", "Obdrzeno od hrace #{current_user.nick} "))
    redirect_to sprava_path(:id => current_user)
  end
end
