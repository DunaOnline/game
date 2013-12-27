class SyselaadsController < ApplicationController
  before_filter :admin_required, :except => [:index, :show]

  def index
    rod = current_user.house
    case params[:kind]
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
	    when 'M'
		    @syselaads = Syselaad.malorodni.where(:subhouse_id => current_user.subhouse)
      else
        @syselaads = Syselaad.narodni.where(:house_id => rod)
    end
  end

  def show
    rod = current_user.house
    case params[:kind]
      when 'L'
        @syselaad = Syselaad.landsraadsky.first
      when 'N'
        @syselaad = Syselaad.narodni.where(:house_id => rod).first
      when 'I'
        @syselaad = Syselaad.imperialni.first
      when 'S'
        @syselaad = Syselaad.systemovy.first
      when 'E'
        @syselaad = Syselaad.mezinarodni.first
	    when 'M'
		    @syselaad = Syselaad.malorodni.where(:subhouse_id => current_user.subhouse).first
      else
        @syselaad = Syselaad.narodni.where(:house_id => rod).first
    end
    if params[:sort] == nil
	    @topics = @syselaad.topics.order("created_at DESC").page(params[:page])
    else
	    @topics = @syselaad.topics.order(params[:sort] + ' ' + params[:direction]).page(params[:page])
    end


  end

  def new
    @syselaad = Syselaad.new
  end

  def create
    @syselaad = Syselaad.new(params[:syselaad])
    if @syselaad.save
      redirect_to @syselaad, :notice => "Uspesne jste vytvorili syselaad."
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
      redirect_to @syselaad, :notice => "Uspesne zmeneny syselaad."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @syselaad = Syselaad.find(params[:id])
    @syselaad.destroy
    redirect_to syselaads_url, :notice => "Uspesne zmazany syselaad."
  end
end
