# encoding: utf-8
class SubhousesController < ApplicationController
  authorize_resource # CanCan

  def index
    @subhouses = Subhouse.where(:house_id => current_user.house).all
  end

  def show

	    @subhouse = Subhouse.find(params[:id])
	    @operations = @subhouse.operations.malorodni.seradit.limit(5)


  end

  def new
    @subhouse = Subhouse.new
  end

  def create
    @subhouse = Subhouse.new
    @subhouse.name = (params[:Malorod])
    @subhouse.house_id = current_user.house.id
    user = User.find(params[:user_id])
    if !user.subhouse
	    if @subhouse.obsazenost_mr
	      if @subhouse.save
		      @subhouse.prirad_mr(current_user)
		      current_user.update_attribute(:general, true)
		      current_user.hlasuj(current_user,"general")
		      @subhouse.zapis_operaci('Založení malorodu.')
	        current_user.zapis_operaci("Založili jste malorod #{@subhouse.name}")
	        redirect_to :back, :notice => 'Malorod úspěšně založený.'
	      else
		      redirect_to :back, :alert => "Prosim vyplnte jmeno mezi 3 az 8 pismenami. "
		    end
	    else
	      redirect_to :back, :alert => 'Nemůžete založit malorod dokud nejsou naplněné již existující.'
	    end
    else
	    redirect_to :back, :alert => 'Jiz jste clenem malorodu.'
	  end
  end

  def edit
    @subhouse = Subhouse.find(params[:id])
  end

  def update
    @subhouse = Subhouse.find(params[:id])
    if @subhouse.update_attributes(params[:subhouse])
      redirect_to @subhouse, :notice => "Successfully updated subhouse."
    else
      render :action => 'edit'
    end
  end

  def sprava_mr
    @subhouse = current_user.subhouse
    @ziadosti = User.malorod(@subhouse.id)
    @market = Market.new
    @markets = Market.zobraz_trh_mr(@subhouse)
    @productions = @subhouse.productions
	  @vice = @subhouse.users.vicegeneral
    @operations = @subhouse.operations.malorodni.seradit.limit(5)
  end

  def vyhod_mr
    user = User.find(params[:id])
    mr = user.subhouse
    if mr.pocet_vyhosteni == Constant.vyhostenie_hraca_mr_max_per_day
	    if user.update_attributes(:subhouse_id => nil, :vicegeneral => false, :general => false)
		    mr.update_attribute(:pocet_vyhosteni, mr.pocet_vyhosteni + 1)
	      user.zapis_operaci("Byl jsi vyhoštěn z malorodu #{mr.name}")
	      mr.zapis_operaci("Z malorodu byl vyhoštěn hráč #{user.nick}.")
	      redirect_to :back, :notice => "Vyhostil jsi hráče #{user.nick} z malorodu"
	    else
	      redirect_to :back, :alert => "Nemůžeš vyhostit hráče #{user.nick}"
	    end
    else
	    redirect_to :back, :alert => "Nemuzes vyhodit vice hracu za den."
	  end
  end

  def prijmi_hrace_mr
    user = User.find(params[:id])
    if user.prijat_do_mr(current_user.subhouse)
      redirect_to :back, :notice => "Prijali jste hrace"
    else
      redirect_to :back, :alert => "Mate maximalni pocet hracu"
    end
  end

  def posli_mr_sur
    malorod = current_user.subhouse
    user = []
    mr = []
    narod = []
    rodu = params[:rod_id_suroviny]
    useru = params[:user_id_suroviny]
    mrdu = params[:mr_id_suroviny]
    user << params[:user_solary].to_f.abs << params[:user_melanz].to_f.abs << params[:user_zkusenosti].to_i.abs << params[:user_material].to_f.abs << params[:user_parts].to_f.abs
    narod << params[:rodu_solary].to_f.abs << params[:rodu_melanz].to_f.abs << params[:rodu_zkusenosti].to_i.abs << params[:rodu_material].to_f.abs << params[:rodu_parts].to_f.abs
    mr << params[:mr_solary].to_f.abs << params[:mr_melanz].to_f.abs << params[:mr_zkusenosti].to_i.abs << params[:mr_material].to_f.abs << params[:mr_parts].to_f.abs
    unless rodu == "" && useru == "" && mrdu == ""
	    msg, flag = malorod.posli_mr_suroviny(narod, user, mr, rodu, useru, mrdu, current_user)
	      if flag

		      redirect_to sprava_mr_path(:id => malorod), :notice => msg
	      else
		      msg += "Nezadal jsi množství na přesun" if msg == ""
		      redirect_to sprava_mr_path(:id => malorod), :alert => msg
	      end
    else
	    redirect_to sprava_mr_path(:id => malorod), :alert => "Zadejte prosim komu poslat suroviny"
    end
  end

  def menuj_vice
	  if params[:menuj] == "true"
	    user = User.find(params[:vicegeneral])
	    if user
		    user.menuj_vice
		    redirect_to :back, :notice => "Hrac #{user.nick} bol zvoleny za Vicegenerala"
		  else
			  redirect_to :back, :alert => "Hlasovani se nezdarilo"
	    end
	  else
	    user = User.find(params[:id])
		  user.zober_vice
	    redirect_to :back, :notice => "Hraci #{user.nick} byl odebran titul Vicegenerala"
		end
  end



  def destroy
    @subhouse = Subhouse.find(params[:id])
    @subhouse.users.each do |user|
      user.update_attribute(:subhouse_id, nil)
    end
    @subhouse.destroy
    redirect_to subhouses_url, :notice => "Successfully destroyed subhouse."
  end
end
