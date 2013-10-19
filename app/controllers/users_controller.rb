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
    elsif params[:general]
      ja.hlasuj(koho, 'general')
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
    @productions = @user.productions.active
    @planets = @user.najdi_planety
    @operations = @user.operations.uzivatelske.seradit.limit(5)
    @subhouse = Subhouse.new
    @subhouses = @user.house.subhouses
  end

  def send_products
    amount = params[:amount]
    production = Production.find(params[:production])
    msg, flag = current_user.move_products(production, amount.to_i)
    if flag
      redirect_to :back, :notice => "Vyrobky poslane"
    else
      redirect_to :back, :alert => msg
    end
  end

  def udalosti
    case params[:typ]
      when "L"
        @udalost = Influence.find(params[:id]).effect
        @leno = Influence.find(params[:id])
      when "P"
        @udalost = Environment.find(params[:id]).property
        @planet = Environment.find(params[:id])
      else
        redirect_to current_user
    end
  end



  def opustit
    if current_user.domovske_leno.planet == Planet.domovska_rodu(House.renegat).first
      redirect_to :back, :notice => "Nemozte opustit renegatov"
    else
      narod = current_user.house
      current_user.opustit_narod
      redirect_to :back, :notice => "Opustili ste narod #{narod.name}"
    end
  end

  def opustit_mr
    mr = current_user.subhouse if current_user.subhouse

    if mr
      current_user.opustit_mr
      redirect_to :back, :notice => "Opustili jste malorod #{mr.name}"
    else
      redirect_to :back, :alert => "Nejste clenem malorodu"
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

  def ziadost_malorod
    subhouse = Subhouse.find(params[:id])
    if current_user.update_attribute(:ziadost_subhouse, subhouse.id) && !current_user.subhouse
      redirect_to :back, :notice => "Žádost do malorodu #{subhouse.name} byla podána"
    else
      redirect_to :back, :alert => "Nemůžte poslat žádost"
    end
  end

  def oprava_katastrofy
    if params[:typ] == "L"
      infl = Influence.find(params[:id])
      if infl.odstran_katastrofu(current_user)
	      redirect_to sprava_path(:id => current_user), :notice => "Zbavili jste se naslednu katastrofy #{infl.effect.name} Zaplatili jste #{infl.effect.price * (infl.duration + 1)}"
      else
	      redirect_to :back, :alert => "Nepodarilo sa odstranit katastrofu"
      end
    elsif params[:typ] == "P"
      enviro = Environment.find(params[:id])
      if enviro.odstran_katastrofu(current_user)
	      redirect_to sprava_path(:id => current_user), :notice => "Zbavili jste se naslednu katastrofy #{enviro.property.name} Zaplatili jste #{enviro.property.price * (enviro.duration + 1)}"
      else
	      redirect_to :back, :alert => "Nepodarilo sa odstranit katastrofu"
      end
    else
      redirect_to :back
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
      when "Dvořan"
        komu.stat_se("court")
        Imperium.zapis_operaci("#{current_user.nick} jmenoval hráče #{komu.nick} na pozici Dvořan.")
      when "Vezír"
        komu.stat_se("vezir")
        Imperium.zapis_operaci("#{current_user.nick} jmenoval hráče #{komu.nick} na pozici Vezír.")
    end
    current_user.house.zapis_operaci("#{current_user.nick} jmenoval hráč #{komu.nick} na pozici #{params[:commit]}.")
    komu.zapis_operaci("#{current_user.nick} mě jmenoval na pozici #{params[:commit]}.")
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
        Imperium.zapis_operaci("#{current_user.nick} odvolal hráče #{komu.nick} z pozice Dvořan.")
      when "Vezir"
        komu.prestat_byt("vezir")
        Imperium.zapis_operaci("#{current_user.nick} odvolal hráče #{komu.nick} z pozice Vezír.")

    end
    current_user.house.zapis_operaci("#{current_user.nick} odvolal hráče #{komu.nick} z pozice #{params[:pravo]}.")
    komu.zapis_operaci("#{current_user.nick} mě odvolal z pozice #{params[:pravo]}.")
    redirect_to :back
  end


  def posli_suroviny
    rod = []
    mr = []
    rod << params[:rod_solary].to_f.abs << params[:rod_melanz].to_f.abs << params[:rod_zkusenosti].to_i.abs << params[:rod_material].to_f.abs << params[:rod_vyrobky].to_f.abs
    mr << params[:mr_solary].to_f.abs << params[:mr_melanz].to_f.abs << params[:mr_zkusenosti].to_i.abs << params[:mr_material].to_f.abs << params[:mr_vyrobky].to_f.abs
    msg, flag = current_user.posli_suroviny(rod, mr)
    if flag
      redirect_to :back, :notice => msg
    else
      msg += "Nezadali ste mnozstvo na presun" if msg == ""
      redirect_to :back, :alert => msg
    end


  end

  def zmena_hesla_f
    @title="Změna hesla uživatele"
    @user = current_user
    @user.password=""
    @user.password_confirmation=""
  end

  def zmena_hesla
    flash[:notice] = nil
    @user = current_user
    old_pass = params[:password][:old]
    new_pass = params[:user][:password]
    new_mail = params[:user][:email]
    if User.authenticate(@user.username, old_pass) # jestli si opravuje vlastni heslo
      unless new_mail == @user.email
        flash[:notice] = 'Email změněn.'
        @user.update_attribute('email', new_mail)
      end

      unless new_pass.blank?
        if new_pass == params['user']['password_confirmation']
          if new_pass.length.between?(4, 40)
            @user.change_password(new_pass)
            flash[:notice] = 'Heslo změněno.'
          else
            flash[:error] = 'Heslo nemá 5-40 znaků.'
          end
        else
          flash[:error] = 'Hesla nejsou stejná.'
        end
      else
        flash[:error] = 'Heslo nemá 5-40 znaků.'
      end
    else
      flash[:error] = 'Neúspěšné ověření původního hesla.'
    end
    render :action => 'zmena_hesla_f'
  end
end
