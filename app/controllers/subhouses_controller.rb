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
    @subhouse = Subhouse.new(params[:subhouse])
    if @subhouse.save
      redirect_to @subhouse, :notice => "Successfully created subhouse."
    else
      render :action => 'new'
    end
  end

  def edit
    @subhouse = Subhouse.find(params[:id])
  end

  def update
    @subhouse = Subhouse.find(params[:id])
    if @subhouse.update_attributes(params[:subhouse])
      redirect_to @subhouse, :notice  => "Successfully updated subhouse."
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
