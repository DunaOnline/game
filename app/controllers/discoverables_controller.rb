class DiscoverablesController < ApplicationController
  authorize_resource # CanCan

  def index
    @discoverables = Discoverable.all
  end

  def show
    @discoverable = Discoverable.find(params[:id])
  end

  def new
    @discoverable = Discoverable.new
  end

  def create
    @discoverable = Discoverable.new(params[:discoverable])
    if @discoverable.save
      redirect_to @discoverable, :notice => "Successfully created discoverable."
    else
      render :action => 'new'
    end
  end

  def edit
    @discoverable = Discoverable.find(params[:id])
  end

  def update
    @discoverable = Discoverable.find(params[:id])
    if @discoverable.update_attributes(params[:discoverable])
      redirect_to @discoverable, :notice  => "Successfully updated discoverable."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @discoverable = Discoverable.find(params[:id])
    @discoverable.destroy
    redirect_to discoverables_url, :notice => "Successfully destroyed discoverable."
  end
end
