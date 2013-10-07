# encoding: utf-8
class TechnologiesController < ApplicationController
  # GET /technologies
  # GET /technologies.json
  def index
    @technologies = Technology.includes(:researches).where(:discovered => 1)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @technologies }
    end
  end

  def narodni_vyskum
    @technologies = Technology.includes(:researches).where(:discovered => 1)


    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @technologies }
    end
  end

  # GET /technologies/1
  # GET /technologies/1.json
  #def show
  #  @technology = Technology.find(params[:id])
  #   respond_to do |format|
  #    format.html # show.html.erb
  #    format.json { render json: @technology }
  #  end
  #end

  # GET /technologies/new
  # GET /technologies/new.json
  #def new
  #  @technology = Technology.new
  #
  #  respond_to do |format|
  #    format.html # new.html.erb
  #    format.json { render json: @technology }
  #  end
  #end
  #
  ## GET /technologies/1/edit
  #def edit
  #  @technology = Technology.find(params[:id])
  #
  #end

  def vylepsi_technology
    @technology = Technology.find(params[:technology])

    if params[:narodni] == "true"
      cena_tech = @technology.cena_narodni_technology(current_user.house)
      if @technology.vylepseno_narodni(current_user.house_id) == @technology.max_lvl_narodni
        flash[:error] = 'Národni výzkum na nejvyšší úrovni'
        redirect_to :action => 'narodni_vyskum'
      else
        if cena_tech > current_user.house.exp
          flash[:error] = "Nedostatek zkušeností pro vynalezeni, potřeba #{(cena_tech - current_user.house.exp).round(0)} exp."
          redirect_to :action => 'narodni_vyskum'
        else
          @technology.vylepsi_narodni(current_user.house_id)
          current_user.update_attributes(:exp => (current_user.house.exp - cena_tech))
          flash[:notice] = 'Národni výzkum byl dokončen.'
          redirect_to :action => 'narodni_vyskum'
        end
      end
    else
      cena_tech = @technology.cena_technology(current_user)
      if @technology.vylepseno(current_user) == @technology.max_lvl
        flash[:error] = 'Výzkum na nejvyšší úrovni'
        redirect_to :action => 'index'
      else
        if cena_tech > current_user.exp
          flash[:error] = "Nedostatek zkušeností pro vynalezeni, potřeba #{(cena_tech - current_user.exp).round(0)} exp."
          redirect_to :action => 'index'
        else
          @technology.vylepsi(current_user)
          current_user.update_attributes(:exp => (current_user.exp - cena_tech))
          flash[:notice] = 'Výzkum byl dokončen.'
          redirect_to :action => 'index'
        end
      end
    end
  end


  # POST /technologies
  # POST /technologies.json
  #def create
  #  @technology = Technology.find(params[:technology])
  #
  #
  #
  #  respond_to do |format|
  #    if @technology.save
  #      format.html { redirect_to @technology, notice: 'Technology was successfully created.' }
  #      format.json { render json: @technology, status: :created, location: @technology }
  #    else
  #      format.html { render action: "new" }
  #      format.json { render json: @technology.errors, status: :unprocessable_entity }
  #    end
  #  end
  #end

  # PUT /technologies/1
  # PUT /technologies/1.json


  #def update
  #  @technology = Technology.find(params[:id])
  #
  #  #respond_with @technology
  #  respond_to do |format|
  #    if @technology.update_attributes(params[:technology])
  #      format.html { redirect_to @technology, notice: 'Research was successfully updated.' }
  #      format.json { head :no_content }
  #    else
  #      format.html { render action: "edit" }
  #      format.json { render json: @technology.errors, status: :unprocessable_entity }
  #    end
  #  end
  #
  #end
  #
  ## DELETE /technologies/1
  ## DELETE /technologies/1.json
  #def destroy
  #  @technology = Technology.find(params[:id])
  #  @technology.destroy
  #
  #  respond_to do |format|
  #    format.html { redirect_to technologies_url }
  #    format.json { head :no_content }
  #  end
  #end
end
