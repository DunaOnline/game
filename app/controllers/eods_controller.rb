class EodsController < ApplicationController
  def index
    @eods = current_user.eods.all
  end

  def show
    
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
  
  def zobraz_eod
    if params[:kam] == "prev"
      if params[:order].to_i == 1
        date = params[:date].to_date - 1
        order = current_user.eods.where(:date => date).maximum(:order)
      else
        date = params[:date].to_date
        order = params[:order].to_i - 1
      end
    elsif params[:kam] == "next"
      max_order = current_user.eods.where(:date => params[:date]).maximum(:order).to_i
      if params[:order].to_i == max_order
        date = params[:date].to_date + 1
        order = 1
      else
        date = params[:date].to_date
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
      
      @solar_income = 0.0
      @exp_income = 0.0
      @material_income = 0.0
      @population_income = 0.0
      @melange_income = 0.0
      
      for eod in @eods_fields do
        @solar_income += eod.solar_income
        @exp_income += eod.exp_income
        @material_income += eod.material_income
        @population_income += eod.population_income
        @melange_income += eod.melange_income
      end 
      
    else
      redirect_to :back, :notice => "Toto je krajni prepocet."
    end    
  end
end
