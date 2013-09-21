class SubhousesController < ApplicationController
  authorize_resource # CanCan

  def index
    @subhouses = Subhouse.all
  end

  def show
    @subhouse = Subhouse.find(params[:id])
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
      redirect_to :back, :notice => "Malorod uspesne zalozeny"
    else
      redirect_to :back, :alert => "Nemozte zalozit malorod"
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
	  @subhouse = Subhouse.find(params[:id])

  end


  def vyhod_mr
	  user = User.find(params[:id])
	  mr = user.subhouse
	  if user.update_attribute(:subhouse_id, nil)
		  redirect_to :back, :notice => "Vyhostili ste hrace #{user.nick} z malorodu"
		  user.zapis_operaci("Byl jste vyhosten z malorodu #{mr.name}")
	  else
		  redirect_to :back, :alert => "Nemuzte vyhostit hrace #{user.nick}"
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
	  msg, flag = malorod.posli_mr_suroviny(narod,user,mr,rodu,useru,mrdu)
	  if flag
		  redirect_to sprava_mr_path(:id => malorod), :notice => msg
	  else
		  msg += "Nezadali ste mnozstvo na presun" if msg == ""
		  redirect_to sprava_mr_path(:id => malorod), :alert => msg
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
