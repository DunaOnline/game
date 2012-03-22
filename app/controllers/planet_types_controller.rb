class PlanetTypesController < ApplicationController
  authorize_resource # CanCan
  
  def index
    @planet_types = PlanetType.all
  end

  def show
    @planet_type = PlanetType.find(params[:id])
  end

  def new
    @planet_type = PlanetType.new
  end

  def create
    @planet_type = PlanetType.new(params[:planet_type])
    if @planet_type.save
      redirect_to @planet_type, :notice => "Successfully created planet type."
    else
      render :action => 'new'
    end
  end

  def edit
    @planet_type = PlanetType.find(params[:id])
  end

  def update
    @planet_type = PlanetType.find(params[:id])
    if @planet_type.update_attributes(params[:planet_type])
      redirect_to @planet_type, :notice  => "Successfully updated planet type."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @planet_type = PlanetType.find(params[:id])
    @planet_type.destroy
    redirect_to planet_types_url, :notice => "Successfully destroyed planet type."
  end
end
