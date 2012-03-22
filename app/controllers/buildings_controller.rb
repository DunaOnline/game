class BuildingsController < ApplicationController
  authorize_resource # CanCan
  
  def index
    @buildings = Building.all
  end

  def show
    @building = Building.find(params[:id])
  end

  def new
    @building = Building.new
  end

  def create
    @building = Building.new(params[:building])
    if @building.save
      redirect_to @building, :notice => "Successfully created building."
    else
      render :action => 'new'
    end
  end

  def edit
    @building = Building.find(params[:id])
  end

  def update
    @building = Building.find(params[:id])
    if @building.update_attributes(params[:building])
      redirect_to @building, :notice  => "Successfully updated building."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @building = Building.find(params[:id])
    @building.destroy
    redirect_to buildings_url, :notice => "Successfully destroyed building."
  end
  
  
  
end
