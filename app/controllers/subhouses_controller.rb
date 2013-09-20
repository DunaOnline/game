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

  def destroy
    @subhouse = Subhouse.find(params[:id])
    @subhouse.destroy
    redirect_to subhouses_url, :notice => "Successfully destroyed subhouse."
  end
end
