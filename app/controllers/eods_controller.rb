class EodsController < ApplicationController
  def index
    @eods = current_user.eods.all
  end

  def show
    if params[:kam] == "prev"
      if params[:order] == 1
        date = params[:date] - 1
        order = current_user.eods.where(:date => date).maximum(:order)
      else
        date = params[:date]
        order = params[:order].to_i - 1
      end
    elsif params[:kam] == "next"
      max_order = current_user.eods.where(:date => params[:date]).maximum(:order)
      if params[:order] == max_order
        date = params[:date] + 1
        order = 1
      else
        date = params[:date]
        order = params[:order].to_i + 1
      end
    else
      date = Date.today
      order = current_user.eods.where(:date => date).maximum(:order)
    end
    
    @eods_global = current_user.eods.where(:date => date, :order => order, :field_id => nil).first
    @eods_fields = current_user.eods.where(:date => date, :order => order)
    if @eods_global && @eods_fields
      @imperator = User.find(@eods_global.imperator).includes(:house) if @eods_global.imperator
      @arrakis = User.find(@eods_global.arrakis).includes(:house) if @eods_global.arrakis
      @leader = User.find(@eods_global.leader) if @eods_global.leader
      if @eods_global.mentats
        mentats = []
        @eods_global.mentats.split('').each do |id|
          mentats << id.to_i
        end
        @mentats = User.where(:id => mentats) 
      end
    else
      redirect_to :back, :notice => "Toto je krajni prepocet."
    end    
  end

  def new
    @eod = Eod.new
  end

  def create
    @eod = Eod.new(params[:eod])
    if @eod.save
      redirect_to @eod, :notice => "Successfully created eod."
    else
      render :action => 'new'
    end
  end

  def edit
    @eod = Eod.find(params[:id])
  end

  def update
    @eod = Eod.find(params[:id])
    if @eod.update_attributes(params[:eod])
      redirect_to @eod, :notice  => "Successfully updated eod."
    else
      render :action => 'edit'
    end
  end

  def destroy
    @eod = Eod.find(params[:id])
    @eod.destroy
    redirect_to eods_url, :notice => "Successfully destroyed eod."
  end
end
