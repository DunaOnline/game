class SystemsController < ApplicationController
  def index
    @systems = System.all
  end

  def show
    @systems = System.all
    @system = System.find(params[:id])
    @planets = @system.planets
  end

  def new
    @system = System.new
  end

  def create
    @system = System.new(params[:system])
    if @system.save
      redirect_to @system, :notice => "Successfully created system."
    else
      render :action => 'new'
    end
  end

  def edit
    @system = System.find(params[:id])
  end

  def update
    @system = System.find(params[:id])
    if @system.update_attributes(params[:system])
      redirect_to @system, :notice  => "Successfully updated system."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @system = System.find(params[:id])
    @system.destroy
    redirect_to systems_url, :notice => "Successfully destroyed system."
  end
end
