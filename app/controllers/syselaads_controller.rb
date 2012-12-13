class SyselaadsController < ApplicationController
  before_filter :admin_required, :except => [:index, :show]
  
  def index
    rod = current_user.house
    case params[:jake]
    when 'L'
      @syselaads = Syselaad.landsraadsky
    when 'N'
      @syselaads = Syselaad.narodni.where(:house_id => rod)
    when 'I'
      @syselaads = Syselaad.imperialni
    when 'S'
      @syselaads = Syselaad.systemovy
    when 'E'
      @syselaads = Syselaad.mezinarodni
    else
      @syselaads = Syselaad.narodni.where(:house_id => rod)
    end
  end

  def show
    @syselaad = Syselaad.find(params[:id])
    rod = current_user.house
    if @syselaad.house != rod && @syselaad.kind == 'N'
      @syselaad = Syselaad.narodni.where(:house_id => rod).first
    else
      
    end
  end

  def new
    @syselaad = Syselaad.new
  end

  def create
    @syselaad = Syselaad.new(params[:syselaad])
    if @syselaad.save
      redirect_to @syselaad, :notice => "Successfully created syselaad."
    else
      render :action => 'new'
    end
  end

  def edit
    @syselaad = Syselaad.find(params[:id])
  end

  def update
    @syselaad = Syselaad.find(params[:id])
    if @syselaad.update_attributes(params[:syselaad])
      redirect_to @syselaad, :notice  => "Successfully updated syselaad."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @syselaad = Syselaad.find(params[:id])
    @syselaad.destroy
    redirect_to syselaads_url, :notice => "Successfully destroyed syselaad."
  end
end
