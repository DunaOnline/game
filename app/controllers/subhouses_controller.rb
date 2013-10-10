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

    if @subhouse.obsazenost_mr
      @subhouse.save
      @subhouse.prirad_mr(current_user)
      current_user.update_attribute(:general, true)
      @subhouse.zapis_operaci('Založení malorodu.')
      redirect_to :back, :notice => 'Malorod úspěšně založený.'
    else
      redirect_to :back, :alert => 'Nemůžete založit malorod dokud nejsou naplněné již existující.'
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

  end

  def vyhod_mr
    user = User.find(params[:id])
    mr = user.subhouse
    if user.update_attributes(:subhouse_id => nil, :vicegeneral => false, :general => false)
      user.zapis_operaci("Byl jsi vyhoštěn z malorodu #{mr.name}")
      mr.zapis_operaci("Z malorodu byl vyhoštěn hráč #{user.nick}.")
      redirect_to :back, :notice => "Vyhostil jsi hráče #{user.nick} z malorodu"
    else
      redirect_to :back, :alert => "Nemůžeš vyhostit hráče #{user.nick}"
    end
  end

  def prijmi_hrace_mr
    user = User.find(params[:id])
    if user.prijat_do_mr(current_user.subhouse)
      msg = "Hráč #{user.nick} byl přijat do malorodu."
      current_user.subhouse.zapis_operaci(msg)
      redirect_to :back, :notice => msg
    else
      redirect_to :back, :alert => "Nepodarilo sa prijat hraca"
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
    user << params[:user_solary].to_f << params[:user_melanz].to_f << params[:user_zkusenosti].to_i << params[:user_material].to_f << params[:user_parts].to_f
    narod << params[:rodu_solary].to_f << params[:rodu_melanz].to_f << params[:rodu_zkusenosti].to_i << params[:rodu_material].to_f << params[:rodu_parts].to_f
    mr << params[:mr_solary].to_f << params[:mr_melanz].to_f << params[:mr_zkusenosti].to_i << params[:mr_material].to_f << params[:mr_parts].to_f
    msg, flag = malorod.posli_mr_suroviny(narod, user, mr, rodu, useru, mrdu)
    if flag
      current_user.zapis_operaci(msg)
      malorod.zapis_operaci(msg)
      redirect_to sprava_mr_path(:id => malorod), :notice => msg
    else
      msg += "Nezadal jsi množství na přesun" if msg == ""
      redirect_to sprava_mr_path(:id => malorod), :alert => msg
    end
  end

  def menuj_vice
    user = User.find(params[:vicegeneral])
    if user.menuj_vice
      redirect_to :back, :notice => "#{user.nick} bol zvoleny za Vicegenerala"
    else
      redirect_to :back, :alert => "#{user.nick} uz je Vicegeneral"
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
