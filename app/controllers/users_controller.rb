class UsersController < ApplicationController
#  authorize_resource # CanCan
  
  before_filter :login_required, :except => [:new, :create]

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
      
      @user.hlasuj(@user,"leader")
      
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

  def update
    @user = current_user
    if @user.update_attributes(params[:user])
      redirect_to root_url, :notice => "Your profile has been updated."
    else
      render :action => 'edit'
    end
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
      
    end
    
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
      
    end
    
    redirect_to :back
  end
end
