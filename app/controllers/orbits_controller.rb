class OrbitsController < ApplicationController
  # GET /orbits
  # GET /orbits.json
  def index
    @orbits = Orbit.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orbits }
    end
  end

  # GET /orbits/1
  # GET /orbits/1.json
  def show
    @orbit = Orbit.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @orbit }
    end
  end

  # GET /orbits/new
  # GET /orbits/new.json
  def new
    @orbit = Orbit.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @orbit }
    end
  end

  # GET /orbits/1/edit
  def edit
    @orbit = Orbit.find(params[:id])
  end

  # POST /orbits
  # POST /orbits.json
  def create
    @orbit = Orbit.new(params[:orbit])

    respond_to do |format|
      if @orbit.save
        format.html { redirect_to @orbit, notice: 'Orbit was successfully created.' }
        format.json { render json: @orbit, status: :created, location: @orbit }
      else
        format.html { render action: "new" }
        format.json { render json: @orbit.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orbits/1
  # PUT /orbits/1.json
  def update
    @orbit = Orbit.find(params[:id])

    respond_to do |format|
      if @orbit.update_attributes(params[:orbit])
        format.html { redirect_to @orbit, notice: 'Orbit was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @orbit.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orbits/1
  # DELETE /orbits/1.json
  def destroy
    @orbit = Orbit.find(params[:id])
    @orbit.destroy

    respond_to do |format|
      format.html { redirect_to orbits_url }
      format.json { head :no_content }
    end
  end
end
